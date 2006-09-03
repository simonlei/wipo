class Page < ActiveRecord::Base
  belongs_to :space
  has_many :comments

  def log_date 
    self.created_at.to_date
  end
end
