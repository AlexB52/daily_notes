require "test_helper"
require "json"

module DailyNotes
  class TestDailyNotes < Minitest::Test
    include Rack::Test::Methods
    include DatabaseTransaction

    def app
      OUTER_APP
    end

    def teardown
      ENV['API_TOKEN'] = nil
    end

    def test_daily_notes_index
      note1 = DailyNote.create(title: 'note 1')
      note2 = DailyNote.create(title: 'note 2')

      get "/daily-notes"

      assert last_response.ok?

      assert_equal [note1, note2].to_json, last_response.body
    end

    def test_post_notes_index
      post "/daily-notes", { title: 'note 1' }

      assert last_response.created?
      assert_equal 1, DailyNote.count

      post "/daily-notes", {}

      assert_equal 400, last_response.status
      assert_equal(
        { "title" => ["can't be blank"] },
        JSON.parse(last_response.body)
      )
    end
  end
end