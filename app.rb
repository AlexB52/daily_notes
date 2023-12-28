require "roda"
require "./config/sequel"

module DailyNotes
  class App < Roda
    plugin :json

    route do |r|

      r.on "daily-notes" do
        r.is do
          r.get do
            DB[:daily_notes].all
          end
        end
      end
    end
  end
end
