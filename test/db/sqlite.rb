#create a connection
if /java/ =~ RUBY_PLATFORM
  adapter = "jdbcsqlite3"
else
  adapter = "sqlite3"
end
ActiveRecord::Base.configurations = {"test" => {
  :adapter => adapter,
  :database => ":memory:"
}.with_indifferent_access}

ActiveRecord::Base.logger = Logger.new('/dev/null')
ActiveRecord::Base.establish_connection(:test)
