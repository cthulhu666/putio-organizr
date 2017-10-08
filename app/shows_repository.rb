class ShowsRepository
  include Import['db']

  QUERY = <<~SQL
    select s.id, s.title, ts_rank(to_tsvector(s.title), to_tsquery(?)) as rank 
    from shows s order by rank desc limit 1
  SQL

  def find_by_title(title)
    tokens = title.scan(/\w+/)
    rs = db.fetch(QUERY, tokens.join(' & ')).first
    rs[:rank] > 0.01 ? rs : nil
  end
end
