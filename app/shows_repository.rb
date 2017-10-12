class ShowsRepository
  include Import['db']
  include Import['config']

  FULLTEXT_SEARCH_QUERY = <<~SQL.freeze
    select s.id, s.title, ts_rank_cd(tsvector, to_tsquery(?), ?) as rank
    from search_view s
    order by rank desc limit 1
  SQL

  def find_by_title(title)
    tokens = title.scan(/\w+/)
    rs = db.fetch(FULLTEXT_SEARCH_QUERY, tokens.join(' | '), config[:rank_normalization]).first
    rs[:rank] > config[:rank_threshold] ? rs : nil
  end
end
