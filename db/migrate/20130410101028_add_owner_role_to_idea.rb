class AddOwnerRoleToIdea < ActiveRecord::Migration
  def change
  	#Smoke and mirror for the user (as requested:) ) It's just for show, not functional.
  	add_column :ideas, :user_role, :integer
  end
end
