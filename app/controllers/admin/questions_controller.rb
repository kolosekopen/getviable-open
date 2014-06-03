class Admin::QuestionsController < Admin::BaseController
  before_filter :find_question, :only => [:edit, :update, :show, :destroy]

  def index
    @survey_section = SurveySection.find(params[:survey_section_id])
    @questions = @survey_section.questions
  end

  def show
  end

  def new
    @survey_section = SurveySection.find(params[:survey_section_id])
    @question = @survey_section.questions.new
  end

  def create
    @survey_section = SurveySection.find(params[:survey_section_id])
    @question = @survey_section.questions.new(params[:question])
    if @question.save
      redirect_to admin_question_answers_path(@question), :notice => "Question successfully created."
    else
      render :new
    end
  end

  def edit
    sections = SurveySection.find_all_by_survey_id(@question.survey_section.survey_id)
    @question_references = Question.where("survey_section_id IN (?)", sections.map(&:id))
  end

  def update
    if @question.update_attributes(params[:question])
      redirect_to admin_survey_section_questions_path(@question.survey_section), :notice => "Question successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_survey_section_questions_path(@question.survey_section), :notice => "question deleted."
  end

  def fetch_answers
    question = Question.find(params[:question_id])
    answers = []
    question.answers.each do |a|
      answers << { :id => a.id, :title => a.title }
    end
    respond_to do |format|
      format.json { render :json => answers.to_json }
    end
  end

  protected

  def find_question
    @question = Question.find(params[:id])
  end
end
