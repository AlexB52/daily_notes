require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.warning = false
end

task default: :test


# Equivalent of bin/sequel -m db/migrations -M 001 sqlite://./db/test.sqlite
# DATABASE_URL = sqlite://./db/test.sqlite
namespace :db do
  desc "Run migrations"
  task :migrate, [:version] do |t, args|
    require "sequel/core"
    Sequel.extension :migration
    version = args[:version].to_i if args[:version]
    Sequel.connect(ENV.fetch("DATABASE_URL", "sqlite://db/database.sqlite")) do |db|
      Sequel::Migrator.run(db, "db/migrations", target: version)
    end
  end
  namespace :test do
    desc "Run migrations on test database"
    task :prepare, [:version] do |t, args|
      ENV["DATABASE_URL"] = "sqlite://db/test.sqlite"
      Rake::Task["db:migrate"].invoke
    end
  end
end
