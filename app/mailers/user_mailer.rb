class UserMailer < ActionMailer::Base
  #Usage:  UserMailer.invitation_confirmation(user).deliver
  default :from => "\"GetViable.com\" <confirmation@getviable.com>"


  def expert_request_confirmation(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "We received your request")
  end

  def expert_request_summary(expert_request)
    @expert_request = expert_request
    email_reciver = ENV["EMAIL_RECEIVER"]
    mail(:to => "GetViable Experts <#{email_reciver}>", :subject => "User requested assistance")
  end

  def invitation(invitation)
    @idea = Idea.find invitation.invitable_id
    @token = invitation.token
    mail(:to => "#{invitation.invitee_email}", :subject => "You have been invited to join an idea.")
  end

  def registration_invitation(reg_invite)
    @token = reg_invite.token
    mail(:to => "#{reg_invite.sent_to}", :subject => "You have been invited to register at...")
  end

  def package_summary(package)
    @package = package
    email_reciver = ENV['EMAIL_RECEIVER']
    mail(:to => "GetViable Package Upgrade <#{email_reciver}>", :subject => "User has updated package.")
  end

end
