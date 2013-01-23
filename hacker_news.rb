require 'rest_client'
require 'nokogiri'
require 'yaml'

page = Nokogiri::HTML(RestClient.get('http://news.ycombinator.com/news'))
# File.read('front_page.html')
# File.open('front_page.html', 'w') do |f|
#   f.puts page
# end

post_urls = page.css('tr > td.title > a')
post_subtexts = page.css('tr > td.subtext')


posts = Hash.new { |hash, key| hash[key] = {} }

30.times do |i|
  next unless post_subtexts[i].children[0].text == "\n"
  id = post_subtexts[i].children[5].attributes['href'].value.split("=")[1].to_i
  posts[id][:url] = post_urls[i].attributes['href'].value
  posts[id][:title] = post_urls[i].children[0].text
  posts[id][:points] = post_subtexts[i].children[1].children[0].text.split(" ")[0].to_i
  posts[id][:user] = post_subtexts[i].children[3].children[0].text
end

File.open('hash.yaml', 'w') do |f|
  f.puts posts.to_yaml
end