class AddPackageToIdeas < ActiveRecord::Migration
  def change
  	add_column :ideas, :package, :integer
    add_index :ideas, :package
  end
end
