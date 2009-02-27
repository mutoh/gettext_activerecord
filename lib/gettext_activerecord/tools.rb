=begin
  tools.rb - Utility functions

  Copyright (C) 2009 Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.
=end

require 'gettext/tools'
require 'gettext_activerecord'
require 'gettext_activerecord/parser'

module GetText
  extend self

  alias :create_mofiles_org :create_mofiles
  alias :update_pofiles_org :update_pofiles

  def update_pofiles(textdomain, files, app_version, options = {})
    GetText::ActiveRecordParser.init(options)
    GetText.update_pofiles_org(textdomain, files, app_version, options)
  end

end
