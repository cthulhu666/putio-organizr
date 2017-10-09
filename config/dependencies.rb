require 'dry/container'
require 'dry/auto_inject'

class Dependencies
  extend Dry::Container::Mixin

  register(:db, memoize: true) do
    db_url = ENV.fetch('DATABASE_URL')

    Sequel.connect(db_url).tap do |db|
      # db.extension :pg_array, :pg_json, :pagination

      db.loggers << Dependencies[:logger] if ENV['DEBUG_SQL']
    end
  end

  register(:putio) do
    PutIo::Client.new
  end

  register(:shows_repository) do
    ShowsRepository.new
  end
end
