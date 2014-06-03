module PagesHelper
	
  # Second navigation is only enabled on two locations
  # Updating routes should also update this part of the code
  def second_navigation_enabled?(idea_id, idea_title)
  	return false if idea_id.nil?
  	current_path = request.url
	(current_path.include?("#{idea_id}/take")) || (current_path.include?("ideas/#{idea_title.parameterize}"))
  end
end
