require 'dry/container'
require 'dry/auto_inject'

class Dependencies
  extend Dry::Container::Mixin

  # https://www.postgresql.org/docs/9.5/static/textsearch-controls.html#TEXTSEARCH-RANKING
  # 1 divides the rank by 1 + the logarithm of the document length
  # 4 divides the rank by the mean harmonic distance between extents (this is implemented only by ts_rank_cd)
  register(:config,
           rank_normalization: 4 | 1,
           rank_threshold: 0.4)

  register(:logger, memoize: true) do
    Logger.new(STDOUT)
  end

  register(:db) do
    db_url = ENV.fetch('DATABASE_URL')

    Sequel.connect(db_url).tap do |db|
      db.loggers << Dependencies[:logger] if ENV['DEBUG_SQL']
    end
  end

  register(:redis) do
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
