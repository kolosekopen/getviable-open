class Admin::AnswersController < Admin::BaseController
  before_filter :find_answer, :only => [:edit, :update, :show, :destroy]

  def index
    @question = Question.find(params[:question_id])
    @answers = @question.answers
  end

  def show
  end

  def new
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(params[:answer])
    if @answer.save
      redirect_to admin_question_answers_path(@question), :notice => "Question successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @answer.update_attributes(params[:answer])
      redirect_to admin_question_answers_path(@answer.question), :notice => "answer successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to admin_question_answers_path(@answer.question), :notice => "answer deleted."
  end

  protected

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
