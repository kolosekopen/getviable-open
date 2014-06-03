class Group < ActiveRecord::Base
  attr_accessible :title, :image_url
  has_many :memberships
  has_many :users, :through => :memberships
end
