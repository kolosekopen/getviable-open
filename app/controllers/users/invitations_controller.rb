class Users::InvitationsController < Devise::InvitationsController
  before_filter :get_idea, :only => [:new]
  
  def new
    super
  end

  def update
    #if this
    #  redirect_to root_path
    #else
    #  super
    #end
    super
  end

  private

  def get_idea
  	@idea = Idea.find params[:idea_id]
  end
end