require "roda"

module DailyNotes
  class App < Roda
    plugin :json

    route do |r|
     { a: 1,b:2 }
    end

    
  end
end
