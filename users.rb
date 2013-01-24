class User
  attr_reader :user_name

  include HackerNewsParser

  def initialize(user)
    @user_name = user
  end

  def karma
    @karma ||= scrape_user_karma(build_user_url(user_name))
  end

  def posts
    @posts ||= scrape_posts(build_submitted_url)
  end

  private

  def build_submitted_url
    "http://news.ycombinator.com/submitted?id=#{user_name}"
  end

  def scrape_posts(url)
    page = parse_page(url)

    post_urls = page.css('tr > td.title > a')
    post_subtexts = page.css('tr > td.subtext')

    posts = Hash.new { |hash, key| hash[key] = {} }

    (post_urls.count - 1).times do |i|
      next unless post_subtexts[i].children[0].name == "span"
      id = post_subtexts[i].children[4].attributes['href'].value.split("=")[1].to_i
      posts[id][:url] = post_urls[i].attributes['href'].value
      posts[id][:title] = post_urls[i].children[0].text
      posts[id][:points] = post_subtexts[i].children[0].children[0].text.split(" ")[0].to_i
      posts[id][:user] = post_subtexts[i].children[2].children[0].text
    end

    posts
  end
  def scrape_user_karma(user_url)
    page = parse_page(user_url)

    karma = page.css('table > tr > td')
    karma[4].children[0].children[1].children[2].children[1].children[0].text
  end
end