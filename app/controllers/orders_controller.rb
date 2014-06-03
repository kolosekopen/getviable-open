class OrdersController < ApplicationController
  before_filter :authenticate_user!

  def new
    @package = Package.find_by_code(params[:code])
    if @package.nil? || @package.idea.user != current_user
      render :action => "fraud"
    else
      @idea = @package.idea
      @order = Order.new(:express_token => params[:token], :package_code => params[:code])
    end
  end

  def create
    @order = Order.new(params[:order])
    package = Package.find_by_code(@order.package_code)
    @idea = package.idea
    @order.ip_address = request.remote_ip
    @order.user = current_user
    @order.package = package
    if package.idea.user == current_user && @order.save
      @response = @order.purchase
      if @response.first
        section = @idea.response_set.survey.sections.where("stage_id = ?", 2).first.id
        redirect_to edit_tour_path(:idea_id => @idea.id, :section => section)
      else
        render :action => "failure"
      end
    else
      render :action => "new"
    end
  end
end
