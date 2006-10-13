class ChangeCommentsToSelfwrite < ActiveRecord::Migration
  def self.up
    remove_column :comments, :commentable_type
    add_column :comments, :page_id, :integer
    Comment.update_all "page_id=commentable_id"
    remove_column :comments, :commentable_id
  end

  def self.down
    add_column :comments, :commentable_id, :integer
    Comment.update_all "commentable_id=page_id"
    add_column :comments, :commentable_type
    Comment.update_all "commentable_type = 'Page'"
    remove_column :comments, :page_id
  end
end
