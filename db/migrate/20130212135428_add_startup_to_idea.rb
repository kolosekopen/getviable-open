class AddStartupToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :startup, :boolean, :default => false
  end
end
