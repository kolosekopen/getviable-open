class ChangeUserToIdeaInResponseSet < ActiveRecord::Migration
  def change
  	rename_column :response_sets, :user_id, :idea_id
  end
end
