`mysqladmin -uroot -proot --force DROP activerecord_unittest`
`mysqladmin -uroot -proot CREATE activerecord_unittest`

#load the parser
GetText::ActiveRecordParser.init(
  :adapter  => "mysql",
  :username => "root",
  :password => "",
  :encoding => "utf8",
  :database => 'activerecord_unittest'
)

#e.g. Ubuntu: ln -s /var/run/mysqld/mysqld.sock /tmp/mysql.sock
ActiveRecord::Base.configurations = {"test" => {
  :adapter  => "mysql",
  :username => "root",
  :password => "",
  :encoding => "utf8",
  :database => 'activerecord_unittest'
}.with_indifferent_access}

ActiveRecord::Base.logger = Logger.new('/dev/null')
ActiveRecord::Base.establish_connection(:test)