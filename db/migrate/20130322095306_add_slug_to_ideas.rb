class AddSlugToIdeas < ActiveRecord::Migration
  def change
  	add_column :ideas, :slug, :string
    add_index :ideas, :slug
  	Idea.find_each(&:save) #TODO: Refactor for clean start
  end
end
