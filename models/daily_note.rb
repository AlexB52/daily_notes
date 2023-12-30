module DailyNotes
  class DailyNote < Sequel::Model
    def to_json(*args)
      attributes.to_json
    end

    def attributes
      columns
        .each
        .with_object({}) { |col, obj| obj[col] = send(col) }
    end

    def validate
      super
      errors.add(:title, "can't be blank") if title.to_s.empty?
    end
  end
end