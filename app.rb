require "roda"

module DailyNotes
  class App < Roda
    plugin :json

    route do |r|

      r.on "daily-notes" do
        r.is do
          r.get do
            { a: 1, b: 2 }
          end
        end
      end
    end
  end
end
