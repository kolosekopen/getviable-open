class Admin::SurveySectionsController < Admin::BaseController

  helper_method :sort_column, :sort_direction, :search_params

  before_filter :find_survey_section, :only => [:edit, :update, :show, :destroy]

  def index
    @survey = Survey.find(params[:survey_id]) if params[:survey_id]
    @survey_sections = SurveySection.find_all_by_survey_id(params[:survey_id]) || SurveySection.all
  end

  def show
    @questions = @survey_section.questions
  end

  def new
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.new
  end

  def create
    @survey = Survey.find(params[:survey_id])
    @survey_section = @survey.sections.new(params[:survey_section])
    if @survey_section.save
      redirect_to admin_survey_section_questions_path(@survey_section), :notice => "survey_section successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @survey_section.update_attributes(params[:survey_section])
      redirect_to admin_survey_survey_sections_path(@survey_section.survey), :notice => "survey_section successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @survey_section.destroy
    redirect_to admin_survey_survey_sections_path(@survey_section.survey), :notice => "survey section deleted."
  end

  protected

  def find_survey_section
    @survey_section = SurveySection.find(params[:id])
  end


end
