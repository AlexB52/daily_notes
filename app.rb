require "roda"
require "./config/sequel"

# populate the table
DB[:items].insert(name: 'abc', price: rand * 100)
DB[:items].insert(name: 'def', price: rand * 100)
DB[:items].insert(name: 'ghi', price: rand * 100)

module DailyNotes
  class App < Roda
    plugin :json

    route do |r|

      r.on "daily-notes" do
        r.is do
          r.get do
            DB[:items].all
          end
        end
      end
    end
  end
end
