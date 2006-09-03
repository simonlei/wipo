class CreateSpaces < ActiveRecord::Migration
  def self.up
    create_table :spaces do |t|
      t.column "name", :string, :null => false
      t.column "description", :string
      t.column "created_at", :datetime
    end
  end

  def self.down
    drop_table :spaces
  end
end
