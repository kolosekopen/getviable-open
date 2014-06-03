class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :idea_id
      t.integer :step_id
      t.integer :event_type
      t.text :content

      t.timestamps
    end
  end
end
