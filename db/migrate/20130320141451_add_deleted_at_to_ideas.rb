class AddDeletedAtToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :deleted_at, :time
  end
end
