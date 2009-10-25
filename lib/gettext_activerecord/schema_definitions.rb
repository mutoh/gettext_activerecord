=begin
  lib/gettext_activerecord/schema_definitions.rb - GetText for ActiveRecord::ConnectionAdapters::Column

  Copyright (C) 2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby or LGPL.

=end

module ActiveRecord #:nodoc:
  module ConnectionAdapters #:nodoc:
    # An abstract definition of a column in a table.
    class Column
      attr_accessor :table_class
      alias :human_name_witout_localized :human_name 

      def human_name_with_gettext_activerecord
        if table_class
          table_class.human_attribute_name(@name)
        else
          @name.humanize
        end
      end
      alias_method_chain :human_name, :gettext_activerecord
    end
  end
end
