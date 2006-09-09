class Space < ActiveRecord::Base
  has_many :pages
  has_many :weblogs
end
