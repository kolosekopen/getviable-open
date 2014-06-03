class RegistrationInvitation < ActiveRecord::Base

  has_one :user

  attr_accessible :active, :sent_to

  before_create :generate_token
  after_create :send_invitation

  def send_invitation
    UserMailer.registration_invitation(self).deliver
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token unless Invitation.where(token: random_token).exists?
    end
  end

end
