class CreateReminderTable < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.references :reminder_for, :polymorphic => true
      t.integer :reminder_type

      t.timestamps
    end
  end
end
