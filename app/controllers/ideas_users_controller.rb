class IdeasUsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_connection
  before_filter :only_owner!, :only => [:update, :destroy]
  before_filter :only_member!, :only => [:destroy]

  def destroy
  	idea = @idea_user.idea
    user = @idea_user.user
    idea.remove_member(user)

    respond_to do |format|
      format.html { redirect_to edit_idea_path(idea), notice: 'Team member removed' }
      format.json { head :no_content }
    end
  end

    def update
    respond_to do |format|
      if @idea_user.update_attributes(params[:ideas_users])
        format.html { redirect_to edit_idea_path(@idea_user.idea), notice: 'Members updated' }
        format.json { head :no_content }
      else
        format.html { redirect_to edit_idea_path(@idea_user.idea), notice: 'Members not updated' }
        format.js { render json: @idea_user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def only_owner!
    unless @idea_user.idea.is_owner? current_user
      redirect_to(ideas_path, :alert => "Only owner can access this page")
    end
  end

  def only_member!
    if @idea_user.idea.is_owner? @idea_user.user
      redirect_to(edit_idea_path(@idea_user.idea), :alert => "You can't delete owner!")
    end
  end

  def get_connection
  	@idea_user = IdeasUsers.find params[:id]
  end
end
