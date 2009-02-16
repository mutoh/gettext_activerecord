$LOAD_PATH.unshift "../lib"

require 'rubygems'
require 'gettext'
require 'gettext_activerecord'
require 'yaml'

require 'book'

config = YAML.load(IO.read("config/database.yml"))["development"]
ActiveRecord::Base.establish_connection(config)

GetText.bindtextdomain_to(ActiveRecord, "sample_ar", :path => "locale")

GetText.set_locale "ja_JP.UTF-8"
book = Book.new
book.title = "Foo"
book.save
puts book.errors.full_messages  #puts Japanese error message.

GetText.set_locale "en"
puts book.errors.full_messages  #puts English error message.
