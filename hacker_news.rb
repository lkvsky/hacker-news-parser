require 'rest_client'
require 'nokogiri'

page = Nokogiri::HTML(RestClient.get('http://news.ycombinator.com/news'))

post_urls = page.css("tr > td.title > a")
post_subtext = page.css("tr > td.subtext")

p post_urls[0].attributes['href'].value # post - url
p post_urls[0].children[0].text # post - title
p post_subtext[0].children[0].children[0].text # post - points
p post_subtext[0].children[2].children[0].text # post - user
