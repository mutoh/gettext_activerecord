=begin
  lib/gettext_activerecord/i18n.rb - GetText for ActiveRecord's I18n.

  Copyright (C) 2009 Masao Mutoh
 
  You may redistribute it and/or modify it under the same
  license terms as Ruby.
=end
 
module I18n  #:nodoc:
  class << self 
    include GetText
    # gettext_activerecord doesn't define backend. So it can be used with another backend.
    def translate_with_gettext_activerecord(key, options = {}) #:nodoc:
      if options[:scope] == [:activerecord, :errors]
        options[:attribute] = key.to_s.split(".")[3]
        options   # This value will be used in ActiveRecord::Base::Errors.localize_error_messages
      else
        translate_without_gettext_activerecord(key, options)
      end
    end
    alias_method_chain :translate, :gettext_activerecord #:nodoc:
    alias_method :t_with_gettext_activerecord, :translate_with_gettext_activerecord #:nodoc:
    alias_method_chain :t, :gettext_activerecord #:nodoc:

  end
end
