=begin
  lib/gettext_activerecord/validations.rb - GetText for ActiveRecord

  Copyright (C) 2006-2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.

  $Id$
=end

module ActiveRecord #:nodoc:
  class RecordInvalid < ActiveRecordError #:nodoc:
    attr_reader :record
    include GetText
    bindtextdomain "gettext_activerecord"

    def initialize(record)
      @record = record
      super(_("Validation failed: %{error_messages}") % 
            {:error_messages => @record.errors.full_messages.join(", ")})
    end
  end

  module Validations # :nodoc:
    class << self
      def real_included(base)
        base.extend ClassMethods
        base.class_eval{
          include GetText
          def gettext(str)  #:nodoc:
            _(str)
          end
          class << self
            def human_attribute_name_with_gettext(attribute_key_name) #:nodoc:
              s_("#{self}|#{attribute_key_name.humanize}")
            end
            alias_method_chain :human_attribute_name, :gettext

            def human_attribute_table_name_for_error(table_name) #:nodoc:
              _(table_name.gsub(/_/, " "))
            end
          end
        }
      end
    end

    if respond_to? :included
      class << self
        def included_with_gettext(base) # :nodoc:
          unless base <= ActiveRecord::Base
            included_without_gettext(base)
          end
          real_included(base)
        end
        alias_method_chain :included, :gettext
      end
    else
      class << self
        # Since rails-1.2.0.
        def append_features_with_gettext(base) # :nodoc:
          unless base <= ActiveRecord::Base
            append_features_without_gettext(base)
          end
          real_included(base)
        end
        alias_method_chain :append_features, :gettext
      end
    end
  end

  # activerecord-1.14.3/lib/active_record/validations.rb
  class Errors #:nodoc:
    include GetText

    bindtextdomain "gettext_activerecord"

    class << self
      include GetText
      def default_error_messages_with_gettext
        @@default_error_messages || {}
      end
      alias_method_chain :default_error_messages, :gettext

      # To use other backends, gettext_activerecord doesn't use backend architecture.
      # You can use GetText with other backends.
      @@default_error_messages = {
          :inclusion => N_("%{fn} is not included in the list"),
          :exclusion => N_("%{fn} is reserved"),
          :invalid => N_("%{fn} is invalid"),
          :confirmation => N_("%{fn} doesn't match confirmation"),
          :accepted  => N_("%{fn} must be accepted"),
          :empty => N_("%{fn} can't be empty"),
          :blank => N_("%{fn} can't be blank"),
          :too_long => N_("%{fn} is too long (maximum is %d characters)"),  
          :too_short => N_("%{fn} is too short (minimum is %d characters)"), 
          :wrong_length => N_("%{fn} is the wrong length (should be %d characters)"),
          :taken => N_("%{fn} has already been taken"),
          :not_a_number => N_("%{fn} is not a number"),
          :greater_than => N_("%{fn} must be greater than %d"),
          :greater_than_or_equal_to => N_("%{fn} must be greater than or equal to %d"),
          :equal_to => N_("%{fn} must be equal to %d"),
          :less_than => N_("%{fn} must be less than %d"),
          :less_than_or_equal_to => N_("%{fn} must be less than or equal to %d"),
          :odd => N_("%{fn} must be odd"),
          :even => N_("%{fn} must be even")
      }
    end

    def each_with_gettext #:nodoc:
      @errors.each_key { |attr| @errors[attr].each { |msg| yield attr, localize_error_message(attr, msg, false) } }
    end
    alias_method_chain :each, :gettext

    # Returns error messages.
    # * Returns nil, if no errors are associated with the specified attribute.
    # * Returns the error message, if one error is associated with the specified attribute.
    # * Returns an array of error messages, if more than one error is associated with the specified attribute.
    # And for GetText,
    # * If the error messages include %{fn}, it returns formatted text such as "foo %{fn}" => "foo Field"
    # * else, the error messages are prepended the field name such as "foo" => "foo" (Same as default behavior).
    # Note that this behaviour is different from full_messages.
    def on_with_gettext(attribute)
      # e.g.) foo field: "%{fn} foo" => "Foo foo", "foo" => "foo". 
      errors = localize_error_messages(false)[attribute.to_s]
      return nil if errors.nil?
      errors.size == 1 ? errors.first : errors
    end
    alias_method_chain :on, :gettext 
    alias :[] :on

    # Returns all the full error messages in an array.
    # * If the error messages include %{fn}, it returns formatted text such as "foo %{fn}" => "foo Field"
    # * else, the error messages are prepended the field name such as "foo" => "Field foo" (Same as default behavior).
    # As L10n, first one is recommanded because the order of subject,verb and others are not same in languages.
    def full_messages_with_gettext
      full_messages = []
      errors = localize_error_messages
      errors.each_key do |attr|
        errors[attr].each do |msg|
   	      next if msg.nil?
	        full_messages << msg
        end
      end
      full_messages
    end
    alias_method_chain :full_messages, :gettext 

    private
    def localize_error_message(attr, obj, append_field) # :nodoc:
      msgid, count, value = obj, 0, ""
      if obj.kind_of? Hash
        msgid = obj[:default].select{|v| v.is_a? String}[0]
        unless msgid
          symbol = obj[:default][0].to_s.split(".").last.to_sym
          msgid = @@default_error_messages[symbol]
        end
        attr, count, value = obj[:attribute], obj[:count], obj[:value]
      end

      msgstr = @base.gettext(msgid)
      msgstr = _(msgid) if msgstr == msgid 
      msgstr = msgstr.gsub("%{fn}", "%{attribute}").gsub("%d", "%{count}").gsub("%{val}", "%{value}")  # for backward compatibility.
      if attr == "base"
        full_message = msgstr
      elsif /%\{attribute\}/ =~ msgstr
        full_message = msgstr % {:attribute => @base.class.human_attribute_name(attr)}
      elsif append_field
        full_message = @base.class.human_attribute_name(attr) + " " + msgstr
      else
        full_message = msgstr
      end
      full_message % {:count => count, :value => value}
    end

    def localize_error_messages(append_field = true) # :nodoc:
      # e.g.) foo field: "%{fn} foo" => "Foo foo", "foo" => "Foo foo". 
      errors = {}
      each_without_gettext {|attr, msg|
        next if msg.nil?
        errors[attr] ||= []
        errors[attr] << localize_error_message(attr, msg, append_field)
      }
      errors
    end

  end
end

