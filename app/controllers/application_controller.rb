class ApplicationController < ActionController::Base
  protect_from_forgery
  include PublicActivity::StoreController
  layout :dynamic_layout
  helper_method :current_group

  hide_action :current_user



  if Rails.env.production?
    # Render 404's
    rescue_from ActiveRecord::RecordNotFound, :with => :missing_record_error
    #Rails 3.2 can't catch this error still, but in routes fix is added
    rescue_from ActionController::RoutingError, :with => :missing_page  

    # Render 501's
    rescue_from ActiveRecord::StatementInvalid, :with => :generic_error
    rescue_from RuntimeError, :with => :generic_error
    rescue_from NoMethodError, :with => :no_method_error
    rescue_from NameError, :with => :generic_error
    rescue_from ActionView::TemplateError, :with => :generic_error
  end

  def current_group
    unless session[:group_id].nil? || Setting.groups_enabled == "false"
      Group.find session[:group_id] 
    end
  end

  def missing_route(exception = nil)
    respond_to do |format|
      format.html {render_404}
    end
  end

    #Error 401
  def missing_record_error(exception)
    respond_to do |format|
      format.html {render_404}
      format.json do
        render :json => {:error => message }
      end
    end
  end

  #Error 501
  def generic_error(exception, message = "OK that didn't work. Try something else.")
    notify_airbrake(exception) if defined?(Airbrake)

    Rails.logger.error "#{exception.class} (#{exception.message})"
    exception.backtrace[0..10].each do |line|
      Rails.logger.error "    " + line
    end

    respond_to do |format|
      format.html {render_501}
      format.json do
        render :json => {:error => message}
      end
    end
  end

  def missing_page(exception = nil)
    respond_to do |format|
      format.html {render_404}
    end
  end

  def no_method_error(exception)
    generic_error(exception, "A potential syntax error in the making!")
  end

  def missing_page(exception = nil)
    respond_to do |format|
      format.html {render_404}
    end
  end

  def render_404
    render :file => "#{Rails.root}/public/404.html", :status => :not_found, :layout => false
    #render :file => File.join(Rails.root, 'public', '404.html'), :status => 404, :layout => false
    return true
  end

  def render_501
    render :file => "#{Rails.root}/public/500.html", :status => 501, :layout => false
    return true
  end


  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User)
        ideas_path
      else
        super
      end
  end

    # Control which layout is used.
  def dynamic_layout
    if !current_user.nil?
      'ideas'
    else
      'application'
    end
  end

  #Redirection with optional notice
  def redirect_to_back(options = {}, default = root_path)
    if has_referer?
      redirect_to :back, :notice => options[:notice]
    else
      redirect_to default, :notice => options[:notice]
    end
  end

  def has_referer?
    !request.env["HTTP_REFERER"].blank? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
  end

end
