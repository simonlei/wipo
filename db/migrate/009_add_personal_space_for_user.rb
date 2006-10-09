class AddPersonalSpaceForUser < ActiveRecord::Migration
  def self.up
    add_column :users, :personal_space_id, :integer, :default=>-1
    User.update_all "personal_space_id = -1"
  end

  def self.down
    remove_column :users, :personal_space_id
  end
end
