Sequel.migration do
  change do
    add_column :daily_notes, :body, String
  end
end