class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :content, :string, :null => false
      t.column :parent_id, :integer
      t.column :page_id, :integer, :null => false
    end
  end

  def self.down
    drop_table :comments
  end
end
