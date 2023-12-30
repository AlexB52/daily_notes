Sequel.migration do
  change do
    create_table(:daily_notes) do
      primary_key :id

      String :title, null: false
    end
  end
end