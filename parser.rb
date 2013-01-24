module HackerNewsParser
  def build_item_url(id)
    "http://news.ycombinator.com/item?id=#{id}"
  end

  def build_user_url(user)
    "http://news.ycombinator.com/user?id=#{user}"
  end

  def parse_page(url)
    Nokogiri::HTML(RestClient.get(url))
  end
end