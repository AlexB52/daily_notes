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
        end
      end
    end
  end
end
