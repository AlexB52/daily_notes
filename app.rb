require "roda"
require "./config/sequel"
require "./models/daily_note"

module DailyNotes
  class App < Roda
    plugin :json

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
