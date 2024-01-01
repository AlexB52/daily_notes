require "roda"
require 'logger'
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

    plugin :common_logger, Logger.new('logs/app.log')
    plugin :halt
    plugin :json
    plugin :request_headers
    plugin :hooks
    plugin :all_verbs
    plugin :common_logger
    plugin :error_handler do |e|
      "Something went wrong: #{e.message}"
    end

    before do
      authorise!(request)
    end

    route do |r|
      r.root do
        response = 200
        "ok"
      end

      r.on "daily-notes" do
        def note_params(request)
          request.params.slice('title', 'body')
        end

        r.get do
          DailyNote.all
        end

        r.post do
          note = DailyNote.new note_params(r)

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
              response.status = 404
              return "unknown daily note"
            end

            note.set(note_params(r))

            if note.save(raise_on_failure: false)
              response.status = 200
              note.attributes
            else
              response.status = 422
              note.errors
            end
          end

          r.delete do
            unless (note = DailyNote[id])
              response.status = 404
              return "unknown daily note"
            end

            if DailyNote[id].delete
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
