class AddDefaultWiki < ActiveRecord::Migration
  def self.up
    Book.create :name => "Your Wiki Name", :url_name => "wiki"
  end

  def self.down
    Book.delete_all
  end
end
