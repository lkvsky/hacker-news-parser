class Post
  attr_accessor :page
  attr_reader :id

  include HackerNewsParser

  def initialize(id)
    @id = id
    @page = parse_page(build_item_url(@id))
  end

  def title
    @title ||= page.css('td.title > a')[0].children[0].text
  end

  def link
    @link ||= page.css('td.title > a')[0].attributes['href'].value
  end

  def points
    @points ||= page.css('td.subtext > span')[0].children[0].text.split(" ")[0].to_i
  end

  def user_name
    @user_name ||= page.css('td.subtext > a')[0].children[0].text
  end

  def comments
    @comments ||= get_all_comments
  end

  def refresh
    @page = parse_page(build_item_url(@id))
  end

  private

  def get_all_comments
    comment_body = page.css('td.default')

    comments = Hash.new { |hash, key| hash[key] = {} }

    comment_body.count.times do |i|
      id = comment_body[i].children[0].children[0].children[2].attributes['href'].value.split("=")[1].to_i
      comments[id][:user] = comment_body[i].children[0].children[0].children[0].children.text
      comments[id][:text] = comment_body[i].children[2].children[0].children.map do |element|
        element.text
      end.join("\n")
    end

    comments
  end

  def inspect
  end
end