class ConnectSurveySections < ActiveRecord::Migration
  def change
  	rename_column :activities, :step_id, :survey_section_id
  	add_column :survey_sections, :stage_id, :integer
  end

end
