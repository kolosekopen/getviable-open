class AddFeaturedToIdea < ActiveRecord::Migration
  def change
  	add_column :ideas, :featured, :boolean, :default => false
  end
end
