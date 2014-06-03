class AddFeaturedUpdatedToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :featured_on, :datetime
  end
end
