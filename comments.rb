class Comment
  include HackerNewsParser

  def initialize(id)
    attributes = find_comment(build_item_url(id))

    @user_name = attributes[:user_name]
    @parent = attributes[:parent]
    @body = attributes[:body]
  end

  def find_comment(comment_url)
    page = parse_page(comment_url)

    comment_header = page.css('span.comhead')
    comment_body = page.css('span.comment')

    attributes = {}

    attributes[:user_name] = comment_header[0].children[0].children[0].text
    attributes[:parent] = comment_header[0].children[2].attributes['href'].value.split('=')[1].to_i
    attributes[:body] = comment_body[0].children[0].children.map do |p|
      p.text
    end.join("\n")

    attributes
  end

  private

  def inspect
  end
end