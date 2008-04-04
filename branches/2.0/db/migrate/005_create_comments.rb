class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title, :limit => 50, :default => ""
      t.string :comment, :default => ""
      t.integer :commentable_id, :default => 0, :null => false
      t.string :commentable_type, :limit => 15, :default => "", :null => false
      t.integer :user_id, :default => 0, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
