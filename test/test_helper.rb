ENV['DATABASE_URL'] = 'sqlite://db/test.sqlite'

require "bundler/setup"

require "minitest/autorun"
require "rackup"
require "rack/test"
require "debug"
require_relative "../app.rb"

module DatabaseTransaction
  def run(*args, &block)
    DB.transaction(rollback: :always, auto_savepoint: true){super}
  end
end

OUTER_APP = Rack::Builder.parse_file("config.ru")
