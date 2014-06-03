class AddFieldsToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :date_of_birth, :date
    add_column :ideas, :industry_id, :integer
  end
end
