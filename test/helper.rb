$KCODE = "UTF8"
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '/../lib')

require 'rubygems'
require 'active_record'

require 'db/sqlite'
#require 'db/mysql'
require 'db/migrate'

# make the test dir of the currently used AR available
require 'ar_hacks/enable'
ar_dir = $LOAD_PATH.select{|v| v =~ /gems\/activerecord-.*\/lib/}[0].sub(/lib$/, "")
$LOAD_PATH.unshift File.join(ar_dir, "test")
require 'cases/helper'

# use local gettext or current gettext gem
begin
  $LOAD_PATH.unshift ENV["GETTEXT_LIB_PATH"] || "../../gettext/lib"
  require 'gettext'
rescue LoadError
  gem 'gettext', '>=2.0.0'
  require 'gettext'
end

# do something strange with AR_6657
AR_TEST_VERSION = /activerecord-([^\/]+)/.match($:.join)[1]
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