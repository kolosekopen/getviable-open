class Membership < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to :group
  belongs_to :idea

  validates :user_id, :uniqueness => {:scope => [:group_id]}
end
