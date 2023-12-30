require "test_helper"

module DailyNotes
  class TestDailyNote < Minitest::Test
    include DatabaseTransaction

    def test_to_json
      note = DailyNote.create(title: 'note 1')

      assert_equal(
        { 'id' => note.id, 'title' => 'note 1' },
        JSON.parse(note.to_json)
      )

      note = DailyNote.new(title: 'note 1')

      assert_equal(
        { 'id' => nil, 'title' => 'note 1' },
        JSON.parse(note.to_json)
      )
    end
  end
end