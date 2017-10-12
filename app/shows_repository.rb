class ShowsRepository
  include Import['db']

  FULLTEXT_SEARCH_QUERY = <<~SQL.freeze
    select s.id, s.title, ts_rank(tsvector, to_tsquery(?)) as rank
    from search_view s
    order by rank desc limit 1
  SQL

  def find_by_title(title)
    tokens = title.scan(/\w+/)
    rs = db.fetch(FULLTEXT_SEARCH_QUERY, tokens.join(' & ')).first
    rs[:rank] > 0.9 ? rs : nil
  end

end
