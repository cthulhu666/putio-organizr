require 'dry/container'
require 'dry/auto_inject'

class Dependencies
  extend Dry::Container::Mixin

  register(:logger, memoize: true) do
    Logger.new(STDOUT)
  end

  register(:db, memoize: true) do
    db_url = ENV.fetch('DATABASE_URL')

    Sequel.connect(db_url).tap do |db|
      # db.extension :pg_array, :pg_json, :pagination

      db.loggers << Dependencies[:logger] if ENV['DEBUG_SQL']
    end
  end

  register(:redis, memoize: true) do
    Redis::Namespace.new('putio-organizr', redis: Redis.new(url: ENV.fetch('REDIS_URL')))
  end

  register(:putio) do
    PutIo::Client.new
  end

  register(:shows_repository) do
    ShowsRepository.new
  end

  register(:accounts_repository) do
    AccountsRepository.new
  end

  register(:organizer) do
    Organizer.new
  end
end
