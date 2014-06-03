class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_user, :only => [ :show ]
  
  def show
  end

  private

  def get_user
  	@user = User.find params[:id]
  end

  def only_owner!
    unless @user == current_user
      redirect_to(ideas_path, :alert => "Only owner can access this page")
    end
  end
end
