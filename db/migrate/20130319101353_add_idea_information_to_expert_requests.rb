class AddIdeaInformationToExpertRequests < ActiveRecord::Migration
  def change
  	add_column :expert_requests, :idea_id, :integer
  	add_column :expert_requests, :survey_section_id, :integer
  end
end
