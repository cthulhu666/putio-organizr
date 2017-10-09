require 'rss'

class TvShows
  include Import['db']

  def import
    1.upto(1000) do |n| # TODO: get upper value from rss?
      url = "http://showrss.info/show/#{n}.rss"
      rss = fetch(url)
      upsert(parse_title(rss.channel.title), url) if rss
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
end
