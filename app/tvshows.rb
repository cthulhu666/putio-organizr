require 'rss'

class TvShows
  include Import['db']

  def import
    1.upto(1000) do |n| # TODO: get upper value from rss?
      url = "http://showrss.info/show/#{n}.rss"
      rss = fetch(url)
      next if rss.nil?
      upsert(parse_title(rss.channel.title), url)
      upsert_items(url, rss.items)
    end
  end

  def fetch(url)
    RSS::Parser.parse(url, true)
  rescue OpenURI::HTTPError => e
    return nil if e.io.status.first == '404'
    sleep 1 && retry if e.io.status.first == '503'
    raise e
  end

  def parse_title(s)
    s.split(':')[1].strip
  end

  def upsert(title, feed)
    db[:shows].insert_conflict.insert(title: title, feed: feed)
  end

  def upsert_items(url, items)
    items.each do |i|
      db[:shows].where(feed: url)
          .update(episode_titles: Sequel.lit("array_uniq(array_append(episode_titles, ?))", i.title))
    end
  end
end
