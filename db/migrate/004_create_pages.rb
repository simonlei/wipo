class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title, :null => false
      t.string :content, :type, :tags
      t.integer :creator_id, :parent_id, :view_count
      t.integer :user_id, :space_id, :null => false
      t.boolean :deleted, :default => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
