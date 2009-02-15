ActiveRecord::Base.configurations = {"test" => {
  :adapter => "sqlite3",
  :database => ":memory:",
}.with_indifferent_access}

ActiveRecord::Base.logger = Logger.new('/dev/null')
ActiveRecord::Base.establish_connection(:test)