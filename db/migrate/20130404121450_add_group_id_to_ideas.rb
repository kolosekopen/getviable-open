class AddGroupIdToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :group_id, :integer
  end
end
