=begin
  lib/gettext_activerecord/parser.rb - parser for ActiveRecord

  Copyright (C) 2005-2009  Masao Mutoh
 
  You may redistribute it and/or modify it under the same
  license terms as Ruby or LGPL.

=end

require 'gettext'
require 'gettext/tools/rgettext'
require 'gettext/tools/parser/ruby'

include GetText

ActiveRecord::Base.instance_eval do
  alias inherited_without_log inherited

  def inherited(subclass)
    puts "registering an ActiveRecord model for later processing: #{subclass}" if $DEBUG
    active_record_classes_list << "#{subclass}" unless subclass.name.empty?
    inherited_without_log(subclass)
  end

  def active_record_classes_list
    $active_record_classes_list ||= []
  end

  def reset_active_record_classes_list
    $active_record_classes_list = []
  end
end

module GetText
  module ActiveRecordParser
    extend GetText
    include GetText
    bindtextdomain "gettext_activerecord"

    @config = {
      :db_yml => "config/database.yml",
      :db_mode => "development",
      :activerecord_classes => ["ActiveRecord::Base"],
      :untranslate_classes => ["ActiveRecord::Base", "ActiveRecord::SessionStore::Session"],
      :untranslate_columns => ["id"],
      :untranslate_table_name => false,
      :use_classname => true,
    }

    @ar_re = nil

    module_function
    def require_rails(file) # :nodoc:
      begin
        require file
      rescue MissingSourceFile
        $stderr.puts _("'%{file}' is not found.") % {:file => file}
      end
    end

    # Sets some preferences to parse ActiveRecord files.
    #
    # * config: a Hash of the config. It can takes some values below:
    #   * :use_classname - If true, the msgids of ActiveRecord become "ClassName|FieldName" (e.g. "Article|Title"). Otherwise the ClassName is not used (e.g. "Title"). Default is true.
    #   * :db_yml - the path of database.yml. Default is "config/database.yml".
    #   * :db_mode - the mode of the database. Default is "development"
    #   * :activerecord_classes - an Array of the superclass of the models. The classes should be String value. Default is ["ActiveRecord::Base"]
    #   * :untranslate_classes - an Array of the modules/class names which is ignored as the msgid.
    #   * :untranslate_columns - an Array of the column names which is ignored as the msgid.
    #   * :untranslate_table_name - a Boolean that avoids table name to be translated if it is true ... Generally, we don't have to translate table_name, do we? Maybe it is not true..... but it is a test
    #   * :adapter - the options for ActiveRecord::Base.establish_connection. If this value is set, :db_yml option is ignored.
    #   * :host - ditto
    #   * :username - ditto
    #   * :password - ditto
    #   * :database - ditto
    #   * :socket - ditto
    #   * :encoding - ditto
    #
    # "ClassName|FieldName" uses GetText.sgettext. So you don't need to translate the left-side of "|". 
    # See <Documents for Translators for more details(http://www.yotabanana.com/hiki/ruby-gettext-translate.html)>.
    def init(config)
      puts "\nconfig: #{config.inspect}\n\n" if $DEBUG
      if config
        config.each{|k, v|
          @config[k] = v
        }
      end
      @ar_re = /class.*(#{@config[:activerecord_classes].join("|")})/
    end

    def translatable_class?(klass)
      if klass.is_a?(Class) && klass < ActiveRecord::Base
        if klass.untranslate_all? || klass.abstract_class? || @config[:untranslate_classes].include?(klass.name)
          false
        else
          true
        end
      else
        true
      end
    end

    def translatable_column?(klass, columnname)
      ! (klass.untranslate?(columnname) || @config[:untranslate_columns].include?(columnname))
    end

    def parse(file, targets = []) # :nodoc:
      puts "parse file #{file}" if $DEBUG
      
      GetText.locale = "en"
      old_constants = Object.constants
      begin
        eval(open(file).read, TOPLEVEL_BINDING)
      rescue
        $stderr.puts _("Ignored '%{file}'. Solve dependencies first.") % {:file => file}
        $stderr.puts $! 
      end
      #loaded_constants = Object.constants - old_constants
      loaded_constants = ActiveRecord::Base.active_record_classes_list
      ActiveRecord::Base.reset_active_record_classes_list
      loaded_constants.each do |classname|
        klass = eval(classname, TOPLEVEL_BINDING)
        if translatable_class?(klass)
          puts "processing class #{klass.name}" if $DEBUG 
          add_target(targets, file, ActiveSupport::Inflector.singularize(klass.table_name.gsub(/_/, " "))) unless @config[:untranslate_table_name]
          unless klass.class_name == classname
            add_target(targets, file, ActiveSupport::Inflector.singularize(klass.to_s_with_gettext.gsub(/_/, " ").downcase))
          end
          begin
            klass.columns.each do |column|
              if translatable_column?(klass, column.name)
                if @config[:use_classname]
                  msgid = klass.to_s_with_gettext + "|" +  klass.human_attribute_name(column.name)
                  else
                  msgid = klass.human_attribute_name(column.name)
                end
                add_target(targets, file, msgid)
              end
            end
          rescue
            $stderr.puts _("No database is available.")
            $stderr.puts $!
          end
        end
      end
      if RubyParser.target?(file)
        targets += RubyParser.parse(file)
      end
      targets
    end

    def add_target(targets, file, msgid) # :nodoc:
      po = PoMessage.new(:normal)
      po.msgid = msgid
      po.sources << "#{file}:-"
      targets << po
      targets
    end

    def target?(file) # :nodoc:
      init(nil) unless @ar_re
      data = IO.readlines(file)
      data.each do |v|
        if @ar_re =~ v
          unless ActiveRecord::Base.connected?
            begin
              require 'rubygems'
            rescue LoadError
              $stderr.puts _("rubygems are not found.") if $DEBUG
            end
            begin
              ENV["RAILS_ENV"] = @config[:db_mode]
              require 'config/boot.rb'
              require 'config/environment.rb'
              require_rails 'activesupport'
              require_rails 'gettext_activerecord'
            rescue LoadError
              require_rails 'rubygems'
              gem 'activerecord'
              require_rails 'activesupport'
              require_rails 'active_record'
              require_rails 'gettext_activerecord'
            end
            begin
              yaml = YAML.load(IO.read(@config[:db_yml]))
              if yaml[@config[:db_mode]]
                ActiveRecord::Base.establish_connection(yaml[@config[:db_mode]])
              else
                ActiveRecord::Base.establish_connection(yaml)
              end
            rescue
              if @config[:adapter]
                ActiveRecord::Base.establish_connection(@config)
              else
                return false
              end
            end
          end
          return true
        end
      end
      false
    end
  end
  
  RGetText.add_parser(GetText::ActiveRecordParser)
end
