class ShowsRepository
  include Import['db']

  QUERY = <<~SQL.freeze
    select s.id, s.title, ts_rank(to_tsvector(s.title), to_tsquery(?)) as rank
    from shows s order by rank desc limit 1
  SQL

  TOKEN_BLACKLIST = %w[www torrenting com 720p 1080p webrip bluray x264 strife].freeze

  def find_by_title(title)
    tokens = filter_tokens(title.scan(/\w+/))
    rs = db.fetch(QUERY, tokens.join(' & ')).first
    rs[:rank] > 0.01 ? rs : nil
  end

  def filter_tokens(tokens)
    tokens.map(&:downcase).reject { |e| e =~ /s\d+e\d+/ } - TOKEN_BLACKLIST
  end
end
