class Users::PasswordsController < Devise::PasswordsController
  layout "login"

  def new
    super
  end

  def edit
    super
  end

end