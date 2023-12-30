require "roda"
require "./config/sequel"
require "./models/daily_note"

unless ENV['API_TOKEN']
  raise 'no API_TOKEN provided'
end

module DailyNotes
  module Authentication
    def authorised?(token)
      token == ENV.fetch('API_TOKEN')
    end
  end

  class App < Roda
    include Authentication

    plugin :json
    plugin :request_headers

    route do |r|
      r.on "daily-notes" do
        r.is do
          r.get do
            unless authorised?(r.headers['Authorization'])
              response.status = 401
              return
            end

            DailyNote.all
          end

          r.post do
            unless authorised?(r.headers['Authorization'])
              response.status = 401
              return
            end

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
