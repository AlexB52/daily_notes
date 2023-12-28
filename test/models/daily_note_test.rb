require "test_helper"

module DailyNotes
  class TestDailyNote < Minitest::Test
    include DatabaseTransaction

    def test_to_json
      note = DailyNote.create(name: 'note 1')

      assert_equal(
        { 'id' => note.id, 'name' => 'note 1' },
        JSON.parse(note.to_json)
      )

      note = DailyNote.new(name: 'note 1')

      assert_equal(
        { 'id' => nil, 'name' => 'note 1' },
        JSON.parse(note.to_json)
      )
    end
  end
end