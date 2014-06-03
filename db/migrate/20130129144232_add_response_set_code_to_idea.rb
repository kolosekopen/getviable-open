class AddResponseSetCodeToIdea < ActiveRecord::Migration
  def change
  	add_column :ideas, :response_set_code, :string
  end
end
