require "roda"
require "./config/sequel"
require "./models/daily_note"

module DailyNotes
  module Authentication
    UNAUTHORISED_PATHS = %w(/)

    def authorise!(request)
      return if UNAUTHORISED_PATHS.include?(request.path)
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
    plugin :all_verbs

    before do
      authorise!(request)
    end

    route do |r|
      r.root do
        response = 200
        "ok"
      end

      r.on "daily-notes" do
        r.get do
          DailyNote.all
        end

        r.post do
          note = DailyNote.new r.params

          if note.save(raise_on_failure: false)
            response.status = 201
            note.attributes
          else
            response.status = 422
            note.errors
          end
        end

        r.on Integer do |id|
          r.put do
            unless (note = DailyNote[id])
              response.status = 422
              return
            end

            note.set(r.params)

            if note.save(raise_on_failure: false)
              response.status = 200
              note.attributes
            else
              response.status = 422
              note.errors
            end
          end

          r.delete do
            if DailyNote[id]&.delete
              response.status = 200
            else
              response.status = 422
            end and return
          end
        end
      end
    end
  end
end
