require 'rest_client'
require 'nokogiri'
require 'yaml'

class HackerNews
  attr_accessor :posts

  def initialize
  end

  def scrape_posts(top_posts_url)
    page = Nokogiri::HTML(RestClient.get(top_posts_url))

    post_urls = page.css('tr > td.title > a')
    post_subtexts = page.css('tr > td.subtext')

    process_posts([post_urls, post_subtexts])
  end

  def process_posts(post_data)
    post_urls, post_subtexts = post_data
    posts = Hash.new { |hash, key| hash[key] = {} }

    (post_urls.count - 1).times do |i|
      next unless post_subtexts[i].children[0].text == "\n"
      id = post_subtexts[i].children[5].attributes['href'].value.split("=")[1].to_i
      posts[id][:url] = post_urls[i].attributes['href'].value
      posts[id][:title] = post_urls[i].children[0].text
      posts[id][:points] = post_subtexts[i].children[1].children[0].text.split(" ")[0].to_i
      posts[id][:user] = post_subtexts[i].children[3].children[0].text
    end

    posts
  end

  def scrape_user_karma(user_url)
    page = Nokogiri::HTML(RestClient.get(user_url))

    karma = page.css('table > tr > td')
    karma[4].children[0].children[1].children[2].children[1].children[0].text
  end

  def save_to_yaml(data, filename)
    File.open("#{filename}.yaml", 'w') do |f|
      f.puts data.to_yaml
    end
  end

  def build_item_url(id)
    "http://news.ycombinator.com/item?id=#{id}"
  end

  def build_user_url(user)
    "http://news.ycombinator.com/user?id=#{user}"
  end

  def scrape_comments(post_url)
    page = Nokogiri::HTML(RestClient.get(post_url))
    #page = Nokogiri::HTML(File.read('post_page.html'))
    comment_body = page.css('td.default')

    comments = Hash.new { |hash, key| hash[key] = {} }

    comment_body.count.times do |i|
      id = comment_body[i].children[0].children[0].children[2].attributes['href'].value.split("=")[1].to_i
      comments[id][:user] = comment_body[i].children[0].children[0].children[0].children.text
      comments[id][:text] = comment_body[i].children[2].children[0].children.map do |element|
        element.text
      end.join(' ')
    end

    p comments
  end
end


# -X- hit the user page, get karma
# create the user in the database

# create the post in the database

# -X- hit the comment page for that post
# scrape comments
# create users (from comments)
# create comments


