class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column "title", :string, :null => false
      t.column "content", :string
      t.column "user_id", :integer, :null => false
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "space_id", :integer, :null => false
      t.column "type", :string
    end
  end

  def self.down
    drop_table :pages
  end
end
