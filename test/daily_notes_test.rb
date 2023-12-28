require "test_helper"
require "json"

OUTER_APP = Rack::Builder.parse_file("config.ru")

module DailyNotes
  class TestDailyNotes < Minitest::Test
    include Rack::Test::Methods
    include DatabaseTransaction

    def app
      OUTER_APP
    end

    def test_daily_notes_index
      note1 = DailyNote.create(name: 'note 1')
      note2 = DailyNote.create(name: 'note 2')

      get "/daily-notes"

      assert last_response.ok?

      assert_equal [note1, note2].to_json, last_response.body
    end
  end
end
