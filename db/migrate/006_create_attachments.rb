class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.string :name, :null => false
      t.integer :size, :page_id
      t.integer :user_id, :null => false
      t.string :description, :content_type
      
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end
