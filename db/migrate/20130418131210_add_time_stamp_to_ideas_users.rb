class AddTimeStampToIdeasUsers < ActiveRecord::Migration
  def change
  	add_column(:ideas_users, :created_at, :datetime)
    add_column(:ideas_users, :updated_at, :datetime)
  end
end
