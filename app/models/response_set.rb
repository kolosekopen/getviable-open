module ResponseSetCustomMethods
  def self.included(base)
    base.send :belongs_to, :idea
    base.send :attr_accessible, :survey, :responses_attributes, :idea_id, :survey_id
  end

  # Getting section id from question from one response. All questions are always in same section
  # Once section id is retrieved, no need to try to catch it later on
  def update_from_ui_hash(ui_hash,current_user = nil)
        section_id = nil
        transaction do
          ui_hash.each do |ord, response_hash|
            api_id = response_hash['api_id']
            fail "api_id missing from response #{ord}" unless api_id

            existing = Response.where(:api_id => api_id).first
            updateable_attributes = response_hash.reject { |k, v| k == 'api_id' }

            if self.class.has_blank_value?(response_hash)
              existing.destroy if existing
            elsif existing
              if existing.question_id.to_s != updateable_attributes['question_id']
                fail "Illegal attempt to change question for response #{api_id}."
              end
              existing.update_attributes(updateable_attributes)
              #TODO: Refactor assigning survey section id
              section_id ||= existing.question.survey_section_id   #Find for which section this update is for
              existing.update_attributes(:survey_section_id => section_id)
           else
              responses.build(updateable_attributes).tap do |r|
                section_id ||= r.question.survey_section_id
                r.api_id = api_id
                r.survey_section_id = section_id
                r.save!
              end
              responses.last.create_activity :create, owner: current_user, recipient: self.idea
            end
          end
        end
        self.record_activity!(section_id) unless section_id.nil? #Don't call if something wrong

  end
    #TODO: Update event type. Refactor this part.
  # Problem if there are (but it shouldn't be) multiple activities in database for each step!!


end

class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods
  include ResponseSetCustomMethods

  # TODO: This has effect when new idea is created - therefore new ResponseSet
  #after_create :record_activity!
  #after_save :record_activity! #TODO: Unless ResponseSet new

  def record_activity!(section_id)
    #return if self.changed_attributes.empty? #Don't update activity if nothing is updated
    self.reload
    responses = self.responses.where(:survey_section_id => section_id)
    if !responses.empty?
      content = add_questions_answers(responses)
      #Find most latest activity that is complying with this search term
      activity = Activity.where(:survey_section_id => section_id, :idea_id => self.idea_id).order("updated_at DESC").first
      if activity.nil? || activity.not_recently_updated?
        Activity.create!(:survey_section_id => section_id, :idea_id => self.idea_id, :content => content, :event_type => Activity::STATUS_ADDED)
      else
        activity.update_attributes(:content => content, :event_type => Activity::STATUS_UPDATED)
      end
    end
  end


  private

  #Method where escaping of answers needs to happen! CGI::escapeHTML()
  def add_questions_answers(responses)
    content = ""
    responses.each do |response|
      answer = response.answer
      if !response.string_value.nil?
        content += "<b>#{response.question.text}</b> - #{CGI::escapeHTML(response.string_value)}\n"
      elsif answer.text == "Date"
        content += "<b>#{response.question.text}</b> - #{response.datetime_value.to_date}\n"
      else
        content += "<b>#{response.question.text}</b> - #{CGI::escapeHTML(response.answer.text.to_str)}\n"
      end
    end
    content
  end
end
