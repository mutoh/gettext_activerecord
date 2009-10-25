=begin
  gettext_activerecord.rb - GetText for ActiveRecord

  Copyright (C) 2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby or LGPL.

=end

require 'gettext'
require 'active_record'
require 'gettext_activerecord/migration'
require 'gettext_activerecord/schema_definitions'
require 'gettext_activerecord/validations'
require 'gettext_activerecord/base'
require 'gettext_activerecord/i18n'
require 'gettext_activerecord/version'

class Class
  def to_s_with_gettext
    to_s
  end
end
