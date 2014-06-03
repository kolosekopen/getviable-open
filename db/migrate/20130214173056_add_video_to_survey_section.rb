class AddVideoToSurveySection < ActiveRecord::Migration
  def change
    add_column :survey_sections, :video_url, :string
  end
end
