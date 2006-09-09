class Page < ActiveRecord::Base
  belongs_to :space
  belongs_to :user
  acts_as_commentable

  def log_date 
    self.created_at.to_date
  end

end
