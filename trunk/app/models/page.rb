class Page < ActiveRecord::Base
  belongs_to :space
  has_many :comments
end
