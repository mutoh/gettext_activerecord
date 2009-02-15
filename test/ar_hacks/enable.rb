# we fake the connection/config library, so that the ar defaults are not loaded
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
require 'connection'

require 'config'
FIXTURES_ROOT = File.expand_path(File.dirname(__FILE__),'../fixtures')

# the cases/repairhelper is missing in the current AR 2.2.2 release
begin
  require 'cases/repair_helper'
rescue LoadError
  require 'repair_helper'
end
include ActiveRecord::Testing::RepairHelper