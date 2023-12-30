require "test_helper"

module DailyNotes
  class TestDailyNote < Minitest::Test
    include DatabaseTransaction

    def test_to_json
      note = DailyNote.create(title: 'note 1')

      assert_equal(
        { 'id' => note.id, 'title' => 'note 1', 'body' => nil },
        JSON.parse(note.to_json)
      )

      note = DailyNote.new(title: 'note 1')

      assert_equal(
        { 'id' => nil, 'title' => 'note 1', 'body' => nil },
        JSON.parse(note.to_json)
      )
    end

    def test_name_validation
      note = DailyNote.new

      refute note.valid?

      assert_equal ["title can't be blank"], note.errors.full_messages
    end
  end
end