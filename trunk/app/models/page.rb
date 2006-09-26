class Page < ActiveRecord::Base
  PAGE_LINK = /\[\[([^\]|]*)[|]?([^\]]*)\]\]/

  belongs_to :space
  belongs_to :creator, :class_name=>'User', :foreign_key=>'creator_id'
  belongs_to :user
  has_many :attachments
  acts_as_commentable

  def log_date 
    updated_at.to_date unless updated_at.nil?
  end

end
