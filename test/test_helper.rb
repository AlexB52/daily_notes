ENV['DATABASE_URL'] = 'sqlite://db/test.sqlite'
ENV['API_TOKEN'] = 'anapitoken'

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