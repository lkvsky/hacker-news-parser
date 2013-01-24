class User
  attr_reader :user_name

  include HackerNewsParser

  def initialize(user)
    @user_name = user
  end

  def karma
    @karma ||= scrape_user_karma
  end

  def posts
    @posts ||= scrape_posts
  end

  def comments
    @comments ||= scrape_comments
  end

  def comments_page
    @comments_page ||= parse_page(comments_url)
  end

  def user_page
    @user_page ||= parse_page(build_user_url(user_name))
  end

  def posts_page
    @posts_page ||= parse_page(submitted_url)
  end

  def refresh
    @comments_page = parse_page(comments_url)
    @posts_page = parse_page(submitted_url)
    @user_page = parse_page(build_user_url(user_name))
  end

  private

  def submitted_url
    "http://news.ycombinator.com/submitted?id=#{user_name}"
  end

  def comments_url
    "http://news.ycombinator.com/threads?id=#{user_name}"
  end

  def scrape_comments
    page = comments_page

    comment_body = page.css('td.default')

    comments = Hash.new { |hash, key| hash[key] = {} }

    comment_body.count.times do |i|
      id = comment_body[i].children[0].children[0].children[2].attributes['href'].value.split("=")[1].to_i
      comments[id][:user] = comment_body[i].children[0].children[0].children[0].children.text

      begin
        comments[id][:parent] = comment_body[i].children[0].children[0].children[4].attributes['href'].value.split('=')[1].to_i
      rescue NoMethodError
        comments[id][:parent] = nil
      end

      comments[id][:text] = comment_body[i].children[2].children[0].children.map do |element|
        element.text
      end.join("\n")
    end
    comments
  end

  def scrape_posts
    page = posts_page

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

  def scrape_user_karma
    page = user_page

    karma = page.css('table > tr > td')
    karma[4].children[0].children[1].children[2].children[1].children[0].text
  end
end