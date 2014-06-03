class Admin::StagesController < Admin::BaseController

  def index
    @stages = Stage.all
  end

  def new
    @stage = Stage.new
  end

  def create
    Stage.create!(params[:stage])
    redirect_to admin_stages_path
  end

  def edit
    @stage = Stage.find(params[:id])
  end

  def update
    @stage = Stage.find(params[:id])
    unless @stage.nil?
      @stage.update_attributes(params[:stage])
    end
    redirect_to admin_stages_path
  end

end
