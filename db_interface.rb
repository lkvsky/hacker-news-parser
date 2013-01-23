require 'sqlite3'

class HNDB < SQLite3::Database
  include Singleton

  def initialize
    super('hacker_news.db')

    self.results_as_hash = true
    self.type_translation = true
  end
end

class HNDBUpdate
  def add_post
  end

  def add_user
  end

  def add_comment
  end

  def get_top_posts
  end

  def get_post_by_id
  end

  def get_post_by_url
  end

  def get_user_by_screen_name
  end

  def get_post_by_user
  end

  def get_comments_by_user
  end
end
