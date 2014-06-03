class EventsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_event, :only => [:show]
  def index
  	@events = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.id, owner_type: "User")
  end

  def show
  end

  def find_event
  	@event = PublicActivity::Activity.find params[:id]  	
  end
end
