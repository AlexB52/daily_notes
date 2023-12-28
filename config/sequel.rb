require "sequel"

# connect to an in-memory database
DB = Sequel.sqlite

# create an items table
DB.create_table :items do
  primary_key :id
  String :name, unique: true, null: false
  Float :price, null: false
end
