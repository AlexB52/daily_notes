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

    def test_authentication
      header 'Authorization', 'nottheapitoken'

      get "/daily-notes"

      assert_equal 401, last_response.status

      post "/daily-notes"

      assert_equal 401, last_response.status
    end

    def test_daily_notes_index
      header 'Authorization', ENV['API_TOKEN']

      note1 = DailyNote.create(title: 'note 1')
      note2 = DailyNote.create(title: 'note 2')

      get "/daily-notes"

      assert last_response.ok?

      assert_equal [note1, note2].to_json, last_response.body
    end

    def test_post_notes_index
      header 'Authorization', ENV['API_TOKEN']

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