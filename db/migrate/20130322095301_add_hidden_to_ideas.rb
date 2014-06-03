class AddHiddenToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :hidden, :boolean, :default => false
    Idea.all.each do |idea|
    	idea.update_attributes(:hidden => false)
    end
  end
end
