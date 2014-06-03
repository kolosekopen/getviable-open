class AddSocialToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :facebook, :string
    add_column :ideas, :twitter, :string
    add_column :ideas, :linkedin, :string
  end
end
