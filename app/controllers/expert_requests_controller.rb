class ExpertRequestsController < ApplicationController
  before_filter :authenticate_user!

  #Todo: Refactor please. Don't show form for expert if some information is wrong
  def new
    begin
      @idea = Idea.find params[:idea_id]
      raise if !@idea.is_owner?(current_user)
      # Be aware that notice will not show, since we are not rendering flash messages just yet.
      redirect_to(idea_path(@idea), :notice => 'Please upgrade to be able to ask an expert.') unless @idea.can_ask_expert?
      @section  = SurveySection.find params[:section_id]
      activity = Activity.where(:idea_id => @idea.id, :survey_section_id => @section.id).last unless @idea.nil? || @section.nil?
      @description = activity.try(:stripped_content) || ""
      @expert_request = ExpertRequest.new
    rescue
      render 'error'
      puts "Error #{$!}"
    end
  end


  # Express gateway
      # :ip                => request.remote_ip,
      # :return_url        => "http://www.google.com",     #url for test only
      # :cancel_return_url => "http://www.google.com",
      # :description => "Donation",
      # :subtotal => 5000,
      # :shipping => 0,
      # :handling => 0,
      # :tax => 0,
      # :items => [{:name => "Donation", :quantity => 1, :amount => 5000, :url => "http://www.google.com"}],
      # :email => "bobjohnson@gmail.com",
      # :address_override => 1,
      # :address => {:name => "Bob Johnson", :zip => "90210", :address1 => "123 Fake St.", :city => "Beverly Hills", :phone => "310-123-4567", :state => "CA", :country => "US"},
      # :no_shipping => true,
      # :allow_guest_checkout => true
  def create
  	@expert_request = ExpertRequest.new(params[:expert_request])
    @expert_request.user_id = current_user.id
    respond_to do |format|
      if @expert_request.terms_conditions && @expert_request.save
        format.html { redirect_to edit_tour_path(params[:expert_request][:idea_id], notice: 'Experts are working on your question.') }
        format.js
      else
        format.html { redirect_to new_expert_request_path(:idea_id => params[:expert_request][:idea_id], :section_id => params[:expert_request][:survey_section_id]), :notice => "Request couldn't be created. Please read and check T&C." }
        format.js
      end
    end
  end
end
