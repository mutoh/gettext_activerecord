ActiveRecord::Schema.define(:version => 1) do
  create_table :books do |t|
    t.string :title, :author_name
  end
end
