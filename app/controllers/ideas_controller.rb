class IdeasController < ApplicationController
  before_filter :authenticate_user!
  layout :resolve_layout
  before_filter :get_idea, :only => [ :show, :edit, :update, :destroy, :vote ]
  before_filter :only_owner!, :only => [ :edit, :update, :destroy ]

  def index
    @ideas = current_user.ideas.where(:startup => false)  #Scope doesn't work in dev, but works in test!
    @startups = current_user.ideas.startups

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @ideas }
    end
  end

  def show
    #ENABLE WHEN EDIT IS ENABLED
    #if request.path != idea_path(@idea)
    #  redirect_to @idea, status: :moved_permanently
    #end
    @activities = Activity.by_idea?(@idea.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @idea }
    end
  end

  def new
    @idea = Idea.new
  end

  def edit
    #TODO: Enable part of the code in show when edit function is enabled!
  end

  #TODO: Make access_code fixed with seeding
  def create
    @idea = Idea.new(params[:idea])
    @idea.user_id = current_user.id
    @idea.group_id = params[:group_id] || current_group.try(:id)

    respond_to do |format|
      surveys = Survey.where(:access_code => Idea.survey_code? ).order("survey_version DESC")
      if !surveys.empty? && @idea.save
        if params[:survey_version].blank?
          @survey = surveys.first
        else
          @survey = surveys.where(:survey_version => params[:survey_version]).first
        end
        @response_set = ResponseSet.
          create!(:survey => @survey, :idea_id => (@idea.nil? ? @idea : @idea.id))
        if (@survey && @response_set)
          flash[:notice] = t('surveyor.survey_started_success')
          @idea.update_attributes(:response_set_code => @response_set.access_code)
          format.html { redirect_to(ideas_path) }
          format.js
        else
          format.html { redirect_to surveyor_index,
                        :notice => t('surveyor.Unable_to_find_that_survey') }
          format.js { render(:update) { |page| page.redirect_to surveyor_index } }
        end
      else
        format.html { redirect_to ideas_path, :notice => "Idea couldn't be created. Please check if image file is jpg/png. " }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @idea.update_attributes(params[:idea])
        format.html { redirect_to @idea, notice: 'Idea was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @idea.destroy

    respond_to do |format|
      format.html { redirect_to ideas_url }
      format.json { head :no_content }
    end
  end

  def likes
    
  end

  def vote
    current_user.vote_for(@idea)
    
  end

  private

  def get_idea
    @idea = Idea.find_by_slug(params[:id])
  end

  def resolve_layout
    case action_name
    when "index"
      (!@ideas.empty? || !@startups.empty?) ? "dashboard" : "basic"
    else
      'basic'
    end
  end

  def only_owner!
    unless @idea.is_owner? current_user
      redirect_to(ideas_path, :alert => "Only owner can access this page")
    end
  end
end
