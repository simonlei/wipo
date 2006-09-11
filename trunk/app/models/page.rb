class Page < ActiveRecord::Base
  PAGE_LINK = /\[\[([^\]|]*)[|]?([^\]]*)\]\]/

  belongs_to :space
  belongs_to :user
  has_many :attachments
  acts_as_commentable

  def log_date 
    self.created_at.to_date
  end

end
