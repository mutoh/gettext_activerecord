=begin
  lib/gettext_activerecord/validations.rb - GetText for ActiveRecord

  Copyright (C) 2006-2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby or LGPL.
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
            def human_attribute_name_with_gettext_activerecord(attribute_key_name) #:nodoc:
              s_("#{self.to_s_with_gettext}|#{attribute_key_name.humanize}")
            end
            alias_method_chain :human_attribute_name, :gettext_activerecord

            def human_attribute_table_name_for_error(table_name) #:nodoc:
              _(table_name.gsub(/_/, " "))
            end
          end
        }
      end
    end

    if respond_to? :included
      class << self
        def included_with_gettext_activerecord(base) # :nodoc:
          unless base <= ActiveRecord::Base
            included_without_gettext_activerecord(base)
          end
          real_included(base)
        end
        alias_method_chain :included, :gettext_activerecord
      end
    else
      class << self
        # Since rails-1.2.0.
        def append_features_with_gettext_activerecord(base) # :nodoc:
          unless base <= ActiveRecord::Base
            append_features_without_gettext_activerecord(base)
          end
          real_included(base)
        end
        alias_method_chain :append_features, :gettext_activerecord
      end
    end
  end

  # activerecord-1.14.3/lib/active_record/validations.rb
  class Errors #:nodoc:
    include GetText

    textdomain "gettext_activerecord"

    class << self
      include GetText

      def default_error_messages_with_gettext_activerecord
        @@default_error_messages || {}
      end
      alias_method_chain :default_error_messages, :gettext_activerecord

      # To use other backends, gettext_activerecord doesn't use backend architecture.
      # You can use GetText with other backends.
      @@default_error_messages = {
          :inclusion => N_("%{attribute} is not included in the list"),
          :exclusion => N_("%{attribute} is reserved"),
          :invalid => N_("%{attribute} is invalid"),
          :confirmation => N_("%{attribute} doesn't match confirmation"),
          :accepted  => N_("%{attribute} must be accepted"),
          :empty => N_("%{attribute} can't be empty"),
          :blank => N_("%{attribute} can't be blank"),
          :too_long => N_("%{attribute} is too long (maximum is %{count} characters)"),  
          :too_short => N_("%{attribute} is too short (minimum is %{count} characters)"), 
          :wrong_length => N_("%{attribute} is the wrong length (should be %{count} characters)"),
          :taken => N_("%{attribute} has already been taken"),
          :not_a_number => N_("%{attribute} is not a number"),
          :greater_than => N_("%{attribute} must be greater than %{count}"),
          :greater_than_or_equal_to => N_("%{attribute} must be greater than or equal to %{count}"),
          :equal_to => N_("%{attribute} must be equal to %{count}"),
          :less_than => N_("%{attribute} must be less than %{count}"),
          :less_than_or_equal_to => N_("%{attribute} must be less than or equal to %{count}"),
          :odd => N_("%{attribute} must be odd"),
          :even => N_("%{attribute} must be even")
      }
    end

    def each_with_gettext_activerecord #:nodoc:
      @errors.each_key { |attr| @errors[attr].each { |msg| yield attr, localize_error_message(attr, msg, false) } }
    end
    alias_method_chain :each, :gettext_activerecord

    # Returns error messages.
    # * Returns nil, if no errors are associated with the specified attribute.
    # * Returns the error message, if one error is associated with the specified attribute.
    # * Returns an array of error messages, if more than one error is associated with the specified attribute.
    # And for GetText,
    # * If the error messages include %{fn}, it returns formatted text such as "foo %{fn}" => "foo Field"
    # * else, the error messages are prepended the field name such as "foo" => "foo" (Same as default behavior).
    # Note that this behaviour is different from full_messages.
    def on_with_gettext_activerecord(attribute)
      # e.g.) foo field: "%{fn} foo" => "Foo foo", "foo" => "foo". 
      errors = localize_error_messages(false)[attribute.to_s]
      return nil if errors.nil?
      errors.size == 1 ? errors.first : errors
    end
    alias_method_chain :on, :gettext_activerecord
    alias :[] :on

    # Returns all the full error messages in an array.
    # * If the error messages include %{fn}, it returns formatted text such as "foo %{fn}" => "foo Field"
    # * else, the error messages are prepended the field name such as "foo" => "Field foo" (Same as default behavior).
    # As L10n, first one is recommanded because the order of subject,verb and others are not same in languages.
    def full_messages_with_gettext_activerecord
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
    alias_method_chain :full_messages, :gettext_activerecord 

    private
    def localize_error_message(attr, object, append_field) # :nodoc:
     obj =  object.respond_to?(:message) ? object.message : object

      msgid, count, value = obj, 0, ""
      if obj.kind_of? Hash
        msgid = obj[:default].select{|v| v.is_a? String}[0]
        unless msgid
          symbol = obj[:default][0].to_s.split(".").last.to_sym
          msgid = @@default_error_messages[symbol]
        end
        #attr, count, value = obj[:attribute], obj[:count], obj[:value]
        count, value = obj[:count], obj[:value]
        attr = obj[:attribute] if obj[:attribute]
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
      each_without_gettext_activerecord {|attr, msg|
        next if msg.nil?
        errors[attr] ||= []
        errors[attr] << localize_error_message(attr, msg, append_field)
      }
      errors
    end

  end
end

