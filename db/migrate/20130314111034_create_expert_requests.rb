class CreateExpertRequests < ActiveRecord::Migration
  def change
    create_table :expert_requests do |t|
      t.integer :type
      t.string :subject
      t.text :problem
      t.boolean :terms_conditions
      t.integer :user_id
      t.string :code

      t.timestamps
    end
  end
end
