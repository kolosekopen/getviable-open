class Admin::IdeasController < Admin::BaseController
  before_filter :find_idea, :only => [:feature]

  def index
    @ideas = Idea.all
  end

  def feature
    @idea.featured!
    redirect_to admin_ideas_path
  end

  protected

  def find_idea
    @idea = Idea.find(params[:idea_id])
  end
end
