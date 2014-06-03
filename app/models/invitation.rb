class Invitation < ActiveRecord::Base
  belongs_to :invitable, polymorphic: true
  
  before_create :generate_token
  after_create :send_invitation

  def send_invitation
    UserMailer.invitation(self).deliver
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless Invitation.where(token: random_token).exists?
    end
  end
  
  def active?
    self.active
  end
  
  def inactive?
    !self.active
  end

  def deactivate!
  	self.active = false
  	save!
  end
  
  def inviter 
    User.find_by_user_id(self.user_id)
  end
  
  def invitee
  	User.find_by_user_id(self.invitee_id)
  end
end
