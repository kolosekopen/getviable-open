class CreateCustomEmails < ActiveRecord::Migration
  def change
    create_table :custom_emails do |t|
      t.integer :user_id
      t.string :original_email
      t.string :custom_email

      t.timestamps
    end
  end
end
