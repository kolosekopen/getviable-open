class ChangeTypeResponsesStringValue < ActiveRecord::Migration
  def up
  	change_column :responses, :string_value, :text
  end

  def down
  	change_column :responses, :string_value, :string
  end
end
