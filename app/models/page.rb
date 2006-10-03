class Page < ActiveRecord::Base
  acts_as_ferret({},{:analyzer=>Ferret::Analysis::RegExpAnalyzer.new(/./,false)})
  acts_as_versioned

  PAGE_LINK = /\[\[([^\]|]*)[|]?([^\]]*)\]\]/

  belongs_to :space
  belongs_to :creator, :class_name=>'User', :foreign_key=>'creator_id'
  belongs_to :user
  has_many :attachments
  acts_as_tree 
  acts_as_commentable

  def log_date 
    updated_at.to_date unless updated_at.nil?
  end

end
