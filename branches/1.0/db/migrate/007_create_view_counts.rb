class CreateViewCounts < ActiveRecord::Migration
  def self.up
    create_table :view_counts do |t|
      t.column :count, :integer
      t.column :object_type, :string
      t.column :object_id, :integer
    end
  end

  def self.down
    drop_table :view_counts
  end
end
