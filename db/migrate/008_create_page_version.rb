class CreatePageVersion < ActiveRecord::Migration
  def self.up
    add_column "pages", "version", :integer
    Page.create_versioned_table
  end

  def self.down
    Page.drop_versioned_table
    remove_column "pages", "version"
  end
end
