class Admin::SurveysController < Admin::BaseController

  helper_method :sort_column, :sort_direction, :search_params

  before_filter :find_survey, :only => [:edit, :update, :show, :destroy]

  def index
    @search = Survey.search(params[:search])
    search_relation = @search.relation
    @surveys = search_relation.order(sort_column + " " + sort_direction).page params[:page]
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(params[:survey])
    if @survey.save
      idea = Idea.new(:title => "Test for: " + @survey.title, :description => "Test Idea", :hidden => true)
      idea.user_id = current_user.id
      idea.save!
      response_set = ResponseSet.create!(:survey => @survey, :idea_id => idea.id)
      idea.update_attributes(:response_set_code => response_set.access_code)
      redirect_to admin_survey_survey_sections_path(@survey), :notice => "survey successfully created."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @survey.update_attributes(params[:survey])
      redirect_to admin_survey_survey_sections_path(@survey), :notice => "survey successfully updated."
    else
      render :edit
    end
  end

  def destroy
    idea = Idea.find_by_title("Test for: "+@survey.title)
    idea.destroy if idea
    @survey.destroy
    redirect_to admin_surveys_path, :notice => "survey deleted."
  end

  protected

  def find_survey
    @survey = Survey.find(params[:id])
  end

  private

  def sort_column
    Survey.column_names.include?(params[:sort]) ? params[:sort] : "title"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def search_params
    { :search => params[:search] }
  end

end
