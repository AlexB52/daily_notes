require "test_helper"
require "json"

module DailyNotes
  class TestAuthentication < Minitest::Test
    include Rack::Test::Methods
    include DatabaseTransaction

    def setup
      @routes = [
        -> { get "/daily-notes" },
        -> { post "/daily-notes" }
      ]
    end

    def app
      OUTER_APP
    end

    def teardown
      ENV['API_TOKEN'] = nil
    end

    def test_enabled_with_no_token
      ENV['API_TOKEN'] = 'theapitoken'

      @routes.each do |route|
        route.call
        assert_equal 401, last_response.status
      end
    end

    def test_enabled_with_valid_token
      ENV['API_TOKEN'] = 'theapitoken'
      header 'Authorization', 'theapitoken'

      @routes.each do |route|
        route.call
        refute_equal 401, last_response.status
      end
    end

    def test_enabled_with_invalid_token
      ENV['API_TOKEN'] = 'theapitoken'
      header 'Authorization', 'anotherapitoken'

      @routes.each do |route|
        route.call
        assert_equal 401, last_response.status
      end
    end

    def test_disabled_with_no_token
      @routes.each do |route|
        route.call
        refute_equal 401, last_response.status
      end
    end

    def test_disabled_with_token
      header 'Authorization', 'anotherapitoken'

      @routes.each do |route|
        route.call
        refute_equal 401, last_response.status
      end
    end
  end
end
