class GroupsController < ApplicationController
  before_filter :authenticate_user!
  def members
  	@current_group = current_group
    @memberships = Membership.where(:group_id => current_group.try(:id))
    @members = User.find_all_by_id(@memberships.map(&:user_id))
  end

  #Find all activity for ideas that belong to all group members
  def activity
    if !current_group.nil?
  	  ideas = Idea.find_all_by_group_id(current_user.groups.map(&:id))
    else
      ideas = current_user.ideas
    end
  	@activities = Activity.find_all_by_idea_id(ideas.map(&:id))
  end

  def my_ideas
    if !current_group.nil?
      @ideas = Idea.where(:user_id => current_user.id, :group_id => current_group.try(:id))
    else
      @ideas = current_user.ideas
    end
    @activities = Activity.find_all_by_idea_id(@ideas.map(&:id))
    render :template => "groups/activity"
  end

  def all_my_ideas
    if !current_group.nil?
      ideas = current_user.ideas.where(:group_id => current_group.id).order('created_at DESC').limit(16)
    else
      ideas = current_user.ideas.where(:group_id => nil).order('created_at DESC').limit(16)
    end
    @activities = Activity.find_all_by_idea_id(ideas.map(&:id))
    render :template => "groups/activity"
  end

    def all_ideas
    if !current_group.nil?
      @ideas = current_user.ideas.where(:group_id => current_group.id).order('created_at DESC')
    else
      @ideas = current_user.ideas.where(:group_id => nil).order('created_at DESC')
    end
    render :template => "groups/all_ideas"
  end

  def featured
    if !current_group.nil?
      ideas = Idea.where(:group_id => current_group.id).featured.order('created_at DESC')
    else
      ideas = Idea.where(:group_id => nil).featured.order('created_at DESC')
    end
    @activities = Activity.find_all_by_idea_id(ideas.map(&:id))
    render :template => "groups/activity"
  end

  def active
    ideas = Idea.most_active?(16)
    @activities = Activity.find_all_by_idea_id(ideas.map(&:id))
    render :template => "groups/activity"
  end

  def newest
    if !current_group.nil?
      ideas = Idea.where(:group_id => current_group.id).startups.order('created_at DESC')
    else
      ideas = Idea.where(:group_id => nil).startups.order('created_at DESC')
    end
    @activities = Activity.find_all_by_idea_id(ideas.map(&:id))
    render :template => "groups/activity"
  end

  def default
    if !current_group.nil?
      ideas = Idea.where(:group_id => current_group.id).order('created_at DESC')
    else
      ideas = Idea.where(:group_id => nil).order('created_at DESC')
    end
    @activities = Activity.find_all_by_idea_id(ideas.map(&:id))
    render :template => "groups/activity"
  end

  def set
    unless params[:group_id].nil?
      group = Group.find params[:group_id]
      session[:group_id] = group.try(:id)
    else
      session[:group_id] = nil
    end
    redirect_to :back
  end
end
