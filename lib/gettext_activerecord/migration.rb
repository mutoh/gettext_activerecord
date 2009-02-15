=begin
  lib/gettext_activerecord/migration.rb - GetText for ActiveRecord::Migration

  Copyright (C) 2009  Masao Mutoh

  You may redistribute it and/or modify it under the same
  license terms as Ruby.

=end

module ActiveRecord #:nodoc:
  class Migration
    extend GetText
    include GetText
  end
end
