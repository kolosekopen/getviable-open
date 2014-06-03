# encoding: UTF-8
module SurveyorControllerCustomMethods
  def self.included(base)
    # base.send :before_filter, :require_user   # AuthLogic
    # base.send :before_filter, :login_required  # Restful Authentication
    # base.send :layout, 'surveyor_custom'

    #ADDED get_idea for action EDIT, UPDATE
    base.send :before_filter, :authenticate_user!
    base.send :before_filter, :get_idea, :only => [:new, :create, :edit, :update] 
    base.send :before_filter, :set_response_set_and_render_context, :only => [:edit, :show]
    base.send :before_filter, :only_owner!, :only => [:new, :create, :edit, :update]
  end

  # Actions
  def new
    super
  end
 def create
    surveys = Survey.where(:access_code => Idea.survey_code?).order("survey_version DESC")
    if params[:survey_version].blank?
      @survey = surveys.first
    else
      @survey = surveys.where(:survey_version => params[:survey_version]).first
    end
    @response_set = ResponseSet.
      create(:survey => @survey, :idea_id => (@idea.nil? ? @idea : @idea.id))
    if (@survey && @response_set)
      flash[:notice] = t('surveyor.survey_started_success')
      @idea.update_attributes(:response_set_code => @response_set.access_code)
      redirect_to(edit_tour_path(:idea_id => @idea.id))
    else
      flash[:notice] = t('surveyor.Unable_to_find_that_survey')
      redirect_to surveyor_index
    end
  end
  def show
    super
  end
  def edit
      if @response_set
        @survey = Survey.with_sections.find_by_id(@response_set.survey_id)
        @sections = @survey.sections
        if params[:section]
          #TODO: Add support when two sets of questions (surveys are added)
          @section = @sections.with_includes.find(section_id_from(params[:section])) || @sections.with_includes.first
        else
          @section = @sections.with_includes.first
        end
        
        if @idea.package.free? and !@section.free?
        # # Be aware that notice will not show, since we are not rendering flash messages just yet.
          redirect_to(edit_idea_path(@idea), notice: 'You can only access the first stage with the free package, please upgrade.')
        end

        @activities = Activity.by_idea?(@idea.id)
        stage = @section.stage
        @stages_before = Stage.for_idea(@idea).before_stage?(stage)
        @stages_after = Stage.for_idea(@idea).after_stage?(stage)

        # @dependents are necessary in case the client does not have javascript enabled, ENABLE THIS LATER ON
        #set_dependents
      else
        flash[:notice] = t('surveyor.unable_to_find_your_responses')
        redirect_to surveyor_index
      end
  end

    def update
      saved = load_and_update_response_set_with_retries

      #TODO: Enable this part in order to have finish button at the end
      #return redirect_with_message(surveyor_finish, :notice, t('surveyor.completed_survey')) if saved && params[:finish]
      
      respond_to do |format|
        format.html do
          if @response_set.nil?
            return redirect_with_message(available_surveys_path, :notice, t('surveyor.unable_to_find_your_responses'))
          else
            flash[:notice] = t('surveyor.unable_to_update_survey') unless saved
            redirect_to edit_tour_path(
              :anchor => anchor_from(params[:section]), :section => section_id_from(params[:section]))
          end
        end
        format.js do
          if @response_set
            render :json => @response_set.reload.all_dependencies
          else
            render :text => "No response set #{@idea.response_set_code}",
              :status => 404
          end
        end
      end
    end

  # Paths
  def surveyor_index
    # most of the above actions redirect to this method
    super # available_surveys_path
  end
  def surveyor_finish
    # the update action redirects to this method if given params[:finish]
    super # available_surveys_path
  end

      def load_and_update_response_set_with_retries(remaining=2)
      begin
        load_and_update_response_set
      rescue ActiveRecord::StatementInvalid => e
        if remaining > 0
          load_and_update_response_set_with_retries(remaining - 1)
        else
          raise e
        end
      end
    end

      def load_and_update_response_set
      ResponseSet.transaction do
        @response_set = ResponseSet.
          find_by_access_code(@idea.response_set_code, :include => {:responses => :answer})
        if @response_set
          saved = true
          if params[:r]
            @response_set.update_from_ui_hash(params[:r], current_user)
          end
          if params[:finish]
            @response_set.complete!
            saved &= @response_set.save
          end
          saved
        else
          false
        end
      end
    end

  private

    # Filters
    #TODO: ActiveRecord::RecordNotFound (Couldn't find Idea without an ID):
    def get_idea
      # @idea = self.respond_to?(:idea) ? self.idea : nil
      # For the sake of example I am using the last idea
      # This should be adjusted to use correct idea based on requirements
      @idea = Idea.find_by_id params[:idea_id]
      #check if belongs to current user
    end

    def set_response_set_and_render_context
      @response_set = ResponseSet.
        find_by_access_code(@idea.try(:response_set_code), :include => {:responses => [:question, :answer]})
      @render_context = render_context
    end

    def only_owner!
      unless @idea.nil? || @idea.is_owner?(current_user) || @idea.member?(current_user) || current_user.admin? 
        redirect_to(root_path, :alert => "Only owner can access this") and return
      end
    end

    def render_context
      if @response_set
        context = {}
        @response_set.responses.each do |resp|
          if resp.question && resp.question.reference_identifier
            ref_id = ("q_" + resp.question.reference_identifier.parameterize.underscore).to_sym
            answer = resp.answer
            if !resp.string_value.nil?
              text = "#{CGI::escapeHTML(resp.string_value)}"
            elsif answer.text == "Date"
              text = "#{resp.datetime_value.to_date}"
            else
              text = "#{CGI::escapeHTML(resp.answer.text.to_str)}"
            end
            if context[ref_id]
              context[ref_id] += ", " + text
            else
              context[ref_id] = text
            end
          end
        end
        return context
      else
        return nil
      end
    end

end
class SurveyorController < ApplicationController
  before_filter :authenticate_user!

  include Surveyor::SurveyorControllerMethods
  include SurveyorControllerCustomMethods
  layout 'dashboard'
end