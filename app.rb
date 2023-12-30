require "roda"
require "./config/sequel"
require "./models/daily_note"

module DailyNotes
  module Authentication
    def authorise!(request)
      return if authorised?(request.headers['Authorization'])

      request.halt(401)
    end

    def authorised?(token)
      return true unless ENV['API_TOKEN']

      token == ENV['API_TOKEN']
    end
  end

  class App < Roda
    include Authentication

    plugin :halt
    plugin :json
    plugin :request_headers
    plugin :hooks

    before do
      authorise!(request)
    end

    route do |r|
      r.on "daily-notes" do
        r.is do
          r.get do
            DailyNote.all
          end

          r.post do
            note = DailyNote.new r.params.slice('title')

            if note.valid? && note.save
              response.status = 201
              note.attributes
            else
              response.status = 400
              note.errors
            end
          end
        end
      end
    end
  end
end
