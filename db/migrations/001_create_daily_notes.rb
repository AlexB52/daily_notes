Sequel.migration do
  change do
    create_table(:daily_notes) do
      primary_key :id

      String :name
    end
  end
end