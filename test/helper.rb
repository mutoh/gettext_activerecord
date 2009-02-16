$KCODE = "UTF8"
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '/../lib')

require 'rubygems'
require 'test/unit'
require 'active_record'

# use local gettext or current gettext gem
begin
  $LOAD_PATH.unshift ENV["GETTEXT_LIB_PATH"] || "../../gettext/lib"
  require 'gettext'
rescue LoadError
  gem 'gettext', '>=2.0.0'
  require 'gettext'
end

require 'gettext_activerecord'

# load database and setup parser
require 'db/sqlite'
#require 'db/mysql'
require 'db/migrate'

# setup fixtures and AR testcase
FIXTURES_ROOT = File.join(File.dirname(__FILE__),'fixtures')
require 'active_record/fixtures'
require 'active_record/test_case'

# the cases/repairhelper is missing in the current AR 2.2.2 release
# try to get it or load our copy
ar_dir = $LOAD_PATH.select{|v| v =~ /gems\/activerecord-.*\/lib/}[0].sub(/lib$/, "")
if File.exist?(File.join(ar_dir,'test','cases','repair_helper.rb'))
  #make the AR/test dir available, and load
  $LOAD_PATH.unshift File.join(ar_dir, "test")
  require 'cases/repair_helper'
else
  require 'vendor/repair_helper'
end
include ActiveRecord::Testing::RepairHelper


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
