class Space < ActiveRecord::Base
  has_many :pages
  has_many :weblogs
  
  def existing_page_titles
    connection.select_all("SELECT title FROM pages WHERE space_id = #{self.id.to_i}").map { |row| row['title'] }
  end
end
