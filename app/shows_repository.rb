class ShowsRepository
  include Import['db']
  include Import['config']
  include Import['logger']

  FULLTEXT_SEARCH_QUERY = <<~SQL.freeze
    with s as (select id, title, ts_delete(tsvector, ARRAY[%STOPWORDS%]) as tsvector from search_view)
    select s.id, s.title, s.tsvector, ts_rank_cd(tsvector, to_tsquery(?), ?) as rank
    from s
      order by rank desc 
      limit 5
  SQL

  STOPWORDS_QUERY = <<~SQL.freeze
    with a as (select unnest(tsvector_to_array(tsvector)) as w from search_view) 
    select w, count(w) as c from a 
      group by w 
      having count(w) > 1500
      order by c desc
  SQL

  def stopwords
    db.fetch(STOPWORDS_QUERY).all
  end

  def find_by_title(title, stopwords)
    query = FULLTEXT_SEARCH_QUERY.gsub('%STOPWORDS%', stopwords.map{|s| "'#{s}'" }.join(','))
    tokens = title.scan(/\w+/)
    rs = db.fetch(query, tokens.join(' | '), config[:rank_normalization]).all
    logger.debug "Potential matches:\n #{rs.join("\n ")}"
    rs.first[:rank] > config[:rank_threshold] ? rs.first : nil
  end
end
