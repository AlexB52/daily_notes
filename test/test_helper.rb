require "bundler/setup"

require "minitest/autorun"
require "rackup"
require "rack/test"
require "debug"

ENV['DATABASE_URL'] = 'sqlite://./db/test.sqlite'
