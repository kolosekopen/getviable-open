class Admin::QuestionGroupsController < Admin::BaseController
  before_filter :find_question_group, :only => [:edit, :update, :show, :destroy]

  def index
    @question_groups = QuestionGroup.all
  end

  def new
    @question_group = QuestionGroup.new
  end

  def create
    if @question_group = QuestionGroup.create(params[:question_group])
      redirect_to admin_question_groups_path, :notice => "Question group successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @question_group.update_attributes(params[:question_group])
      redirect_to admin_question_groups_path, :notice => "Question group successfully updated."
    else
      render :edit
    end
  end

  protected

  def find_question_group
    @question_group = QuestionGroup.find(params[:id])
  end
end
