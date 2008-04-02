class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column :title, :string, :null => false
      t.column :content, :string
      t.column :creator_id, :integer
      t.column :user_id, :integer, :null => false
      t.column :parent_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :space_id, :integer, :null => false
      t.column :type, :string
      t.column :deleted, :boolean, :default => false
      t.column :view_count, :integer
      t.column :tags, :string
    end
  end

  def self.down
    drop_table :pages
  end
end
