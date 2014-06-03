class AddCustomFieldsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :raw, :boolean, :default => false
    add_column :questions, :question_reference_id, :integer
  end
end
