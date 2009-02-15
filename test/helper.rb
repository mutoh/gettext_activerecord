require 'test/unit'

$KCODE = "U"
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '/../lib')

require 'rubygems'

require 'active_record'
ar_dir = $LOAD_PATH.select{|v| v =~ /gems\/activerecord-.*\/lib/}[0].sub(/lib$/, "")
$LOAD_PATH.unshift File.join(ar_dir, "test")
$LOAD_PATH.unshift File.join(ar_dir, "test/connections/native_mysql")
require File.join(ar_dir, "test/cases/helper")

begin
  require 'gettext'
rescue LoadError
  $LOAD_PATH.unshift ENV["GETTEXT_LIB_PATH"] || "../../gettext/lib"
  require 'gettext'
end

begin
  `rake dropdb`
rescue
end
begin
  `rake createdb`
rescue
end

