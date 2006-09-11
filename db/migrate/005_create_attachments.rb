class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.column :name, :string, :null => false
      t.column :size, :integer
      t.column :page_id, :integer
      t.column :user_id, :integer, :null => false
      t.column :created_at, :datetime
      t.column :description, :string
    end
  end

  def self.down
    drop_table :attachments
  end
end
