require "test_helper"

OUTER_APP = Rack::Builder.parse_file("config.ru")

class TestDailyNotes < Minitest::Test
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_daily_notes_index
    get "/daily-notes"

    assert last_response.ok?
  end
end