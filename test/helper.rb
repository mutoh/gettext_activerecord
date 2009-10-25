# encoding: utf-8

unless RUBY_VERSION >= "1.9.0"
  $KCODE = "UTF8"
end
$LOAD_PATH.unshift "."
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '/../lib')

require 'rubygems'
require 'test/unit'
require 'active_record'

# use local gettext or current gettext gem
begin
  $LOAD_PATH.unshift ENV["GETTEXT_LIB_PATH"] || "../../gettext/lib:../"
  require 'gettext'
rescue LoadError
  gem 'gettext', '>=2.0.0'
  require 'gettext'
end

require 'gettext_activerecord'

# load database and setup parser
require 'db/sqlite'
require 'db/migrate'

# do something strange with AR_6657
AR_TEST_VERSION = /activerecord-([^\/]+)/.match($LOAD_PATH.join)[1]
if AR_TEST_VERSION > "2.0.0"
  #ticket 6657 on dev.rubyonrails.org require this but it becames removed(?)
  AR_6657 = true
else
  AR_6657 = false
end
puts "The activerecord svn version is #{$1}"

# Make with_scope public for tests
class << ActiveRecord::Base
  public :with_scope, :with_exclusive_scope
end

