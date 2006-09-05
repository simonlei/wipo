class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.column "title", :string, :null => false
      t.column "content", :string
      t.column "space_id", :integer, :null => false
      t.column "user_id", :integer, :null => false
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
    end
  end

  def self.down
    drop_table :pages
  end
end
