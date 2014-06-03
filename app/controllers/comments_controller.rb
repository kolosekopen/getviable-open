class CommentsController < ApplicationController
def new
end
 
 #TODO: Refactor - Create.js as it updates one unexisting id - uses two different calls
 def create
  model_name = params[:comment][:commentable_type]
  record_commentable = model_name.constantize.find(params[:comment][:commentable_id])
  @comment = record_commentable.comments.create(:commentable => record_commentable, :user_id => current_user.id, :comment => params[:comment][:comment] )
  #record_commentable.class.name.include? "Activity"
  @idea = record_commentable.idea
  @activities = Activity.by_idea?(@idea.id)
  @activity = record_commentable
  @comment.create_activity :create, owner: current_user, recipient: @idea
  #TODO: Refactor record_commentable.idea_id don't use straight from record, as it might be something different!!!
	  respond_to do |format|
	      format.html { redirect_to( edit_tour_path(:idea_id => record_commentable.idea_id, :survey_section_id => record_commentable.survey_section_id)) }
	      format.js
	  end
  end
end
