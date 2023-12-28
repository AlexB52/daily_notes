module DailyNotes
  class DailyNote < Sequel::Model
    def to_json(*args)
      columns
        .each
        .with_object({}) { |col, obj| obj[col] = send(col) }
        .to_json
    end
  end
end