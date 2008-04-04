class CreateSpaces < ActiveRecord::Migration
  def self.up
    create_table :spaces do |t|
      t.string :name, :null => false
      t.string :description
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :spaces
  end
end
