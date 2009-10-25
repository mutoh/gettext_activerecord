=begin
  lib/gettext_activerecord/base.rb - GetText for ActiveRecord::Base

  Copyright (C) 2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby or LGPL.
=end

module ActiveRecord #:nodoc:
  class Base
    include GetText
    include Validations

    @@gettext_untranslate = Hash.new(false)
    @@gettext_untranslate_columns = {}

    class << self
      # Untranslate all of the tablename/fieldnames in this model class.
      #  (e.g.)
      #  Person < ActiveRecord::Base
      #    untranslate_all
      #  end
      def untranslate_all
        @@gettext_untranslate[self] = true
      end

      # Returns true if "untranslate_all" is called. Otherwise false.
      def untranslate_all?
        @@gettext_untranslate[self]
      end

      # Sets the untranslate columns.
      #  (e.g.) 
      #  Person < ActiveRecord::Base
      #    untranslate :age, :address
      #  end
      def untranslate(*w)
        ary = @@gettext_untranslate_columns[self] || []
        ary += w.collect{|v| v.to_s}
        @@gettext_untranslate_columns[self] = ary
      end
      
      # Returns true if the column is set "untranslate".
      #  (e.g.) untranslate? :foo
      def untranslate?(columnname)
        ary = @@gettext_untranslate_columns[self] || []
        ary.include?(columnname)
      end

      def untranslate_data #:nodoc:
        [@@gettext_untranslate[self], @@gettext_untranslate_columns[self] || []]
      end

      def columns_with_gettext_activerecord
        unless defined? @columns
          @columns = nil 
        end
        unless @columns
          @columns = columns_without_gettext_activerecord
          @columns.each {|column| 
            column.table_class = self
          }
        end
        @columns
      end
      alias_method_chain :columns, :gettext_activerecord
    end
  end

end
