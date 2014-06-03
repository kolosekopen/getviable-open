module EventsHelper
  def event_sentence(event, activity)
  	case event.trackable.class.name
  	when "Comment"
  		"#{ event.owner.name } commented <span class=\"bold\">#{event.trackable.commentable.survey_section.title}</span> in #{event.trackable.commentable.survey_section.stage.title}".html_safe
  	when "Response"
  		" has updated #{link_to activity.survey_section.title, edit_tour_path(:idea_id => activity.idea_id, :section => activity.survey_section_id)} in <b>#{activity.survey_section.stage.title}</b>".html_safe
    else 
    	" event has remainded private"
    end
  end

  def event_activity(event)
    case event.trackable.class.name
    when "Comment"
      event.trackable.commentable
    when "Response"
      Activity.where(:survey_section_id => event.trackable.survey_section_id, :idea_id => event.trackable.response_set.idea_id).first
    else 
      nil
    end
    
  end
end
