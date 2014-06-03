class IdeasUsers < ActiveRecord::Base
  #TODO: Disable these attributes - user_id and idea_id after migrations for populating owner to ideasusers table
  attr_accessible :role_id, :user_id, :idea_id
  
  BUSINESS = 1.freeze
  TECHNICAL = 2.freeze
  PRODUCT = 3.freeze
  ADVISOR = 4.freeze
  MENTOR = 5.freeze
  INVESTOR = 6.freeze

  TYPES = {
	  BUSINESS => "Business",
	  TECHNICAL => "Technical",
	  PRODUCT => "Product",
	  ADVISOR => "Advisor (view only)",
	  MENTOR => "Mentor (view only)",
	  INVESTOR => "Investor (view only)"
  }

  belongs_to :user
  belongs_to :idea, :touch => true

  #validates :user_id, :uniqueness => {:scope => [:idea_id]}

  def public?
    self.role_id == 4 || self.role_id == 5 || self.role_id == 6
  end

  def private?
    self.role_id == 1 || self.role_id == 2 || self.role_id == 3
  end

end