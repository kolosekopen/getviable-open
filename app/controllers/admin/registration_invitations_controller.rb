class Admin::RegistrationInvitationsController < Admin::BaseController

  def new
  end

  def create
    emails = params[:emails]
    emails = emails.gsub(/\s+/, "")
    emails.split(';').each do |email|
      RegistrationInvitation.create!(sent_to: email) if email != ""
    end
    redirect_to admin_path
  end

end
