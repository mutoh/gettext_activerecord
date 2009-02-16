ActiveRecord::Schema.define(:version => 1) do
  create_table :topics do |t|
    t.string :title, :author_name, :author_email_address
    t.datetime :written_on
    t.timestamp :bonus_time
    t.date :last_read
    t.text :content
    t.boolean :approved
    t.integer :replies_count, :default=>0, :null=>false
    t.integer :parent_id
    t.string :type, :limit=>50
  end

  create_table :developers do |t|
    t.string :name, :limit=>100
    t.integer :salary, :default=>70_000, :null=>false
    t.timestamps
  end

  create_table :books do |t|
    t.string :title, :limit=>100
    t.integer :price, :default=>70_000, :null=>false
    t.timestamps
  end

  create_table :users do |t|
    t.string :first_name, :last_name, :limit=>100
    t.timestamps
  end

  create_table :people do |t|
    t.string :first_name, :limit=>100
    t.integer :lock_version, :null=>false
    t.timestamps
  end

  create_table :inept_wizards do |t|
    t.string :name,:city,:type, :limit=>100
    t.timestamps
  end
end
