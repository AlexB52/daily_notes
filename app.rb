require "roda"
require "./config/sequel"

# populate the table
DB[:daily_notes].insert(name: 'abc')
DB[:daily_notes].insert(name: 'def')
DB[:daily_notes].insert(name: 'ghi')

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
