class RemovePackageFromIdeas < ActiveRecord::Migration
  def change
  	remove_index(:packages, :name => 'index_packages_on_code')
  	remove_index(:packages, :name => 'index_packages_on_idea_id')
  	remove_index(:ideas, :name => 'index_ideas_on_package')
  	remove_column :ideas, :package
  end
end
