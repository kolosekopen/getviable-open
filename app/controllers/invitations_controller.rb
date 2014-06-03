class InvitationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_invitable

  def new
    @invitation = @invitable.invitations.new
  end

  def create
    @invitation = @invitable.invitations.new(params[:invitation])
    @invitation.user_id = current_user.id
    if @invitation.save
      redirect_to_back(:notice => "Thank you, your invitation has been sent to: #{@invitation.invitee_email}")
    else
      render :new
    end
  end

  #It can be expanded for accepting invitations for groups or anything else
  def accept
  	token = params[:id]
  	unless token.empty?
      invitation = Invitation.find_by_token(token)
      if !invitation.nil? && invitation.active?
        record = invitation.invitable_type.singularize.classify.constantize.find(invitation.invitable_id)
        unless record.users.include? current_user
          IdeasUsers.create(:user_id => current_user.id, :idea_id => record.id, :role_id => invitation.invitee_role_id)
        end 
        invitation.deactivate!
        redirect_to idea_path(record), :notice => "Congratulations, you have joined the team of this idea"      	
      else
        redirect_to root_path, :notice => "Invitation is not valid"  	
      end  
  	else
      redirect_to root_path, :notice => "Invitation is not valid"
  	end
  end

  private

  def load_invitable
    resource, id = request.path.split('/')[1, 2]
    @invitable = resource.singularize.classify.constantize.find(id)
  end
end
