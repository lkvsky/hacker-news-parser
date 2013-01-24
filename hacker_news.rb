require 'rest_client'
require 'nokogiri'
require 'yaml'

require './parser'
require './posts'
require './comments'
require './users'


class HackerNews
  attr_accessor :posts

  include HackerNewsParser

  def initialize
  end

  def scrape_posts(top_posts_url)
    page = parse_page(top_posts_url)

    post_urls = page.css('tr > td.title > a')
    post_subtexts = page.css('tr > td.subtext')

    process_posts([post_urls, post_subtexts])
  end

  def process_posts(post_data)
    post_urls, post_subtexts = post_data
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

  def save_to_yaml(data, filename)
    File.open("#{filename}.yaml", 'w') do |f|
      f.puts data.to_yaml
    end
  end
end







# -X- hit the user page, get karma
# create the user in the database

# create the post in the database

# -X- hit the comment page for that post
# scrape comments
# create users (from comments)
# create comments


