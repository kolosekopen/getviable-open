class Users::RegistrationsController < Devise::RegistrationsController
   layout :resolve_layout

   before_filter :check_invitation, :only => :new

  def new
    super
  end

  def create
    super
  end

  def edit
   	super
  end
  
  def update
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(params[:user])
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)

      @user.update_without_password(params[:user])
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to profile_path(@user)
    else
      render "edit"
    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    return false
    !params[:user][:email].blank? || !params[:user][:password].blank?
  end


   def resolve_layout
    case action_name
    when "edit"
      "dashboard"
    when "update"
      "dashboard"
    else
      'login'
    end
  end

  def check_invitation
    redirect_to :root if params[:iid].nil? ||
                         RegistrationInvitation.find_by_token(params[:iid]).nil? ||
                         !RegistrationInvitation.find_by_token(params[:iid]).active
    @reg_invite = RegistrationInvitation.find_by_token(params[:iid]) unless params[:iid].nil?
  end

end