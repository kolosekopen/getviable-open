class AddNotificationFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :updates_notifications, :boolean
  	add_column :users, :comments_notifications, :boolean
  end
end
