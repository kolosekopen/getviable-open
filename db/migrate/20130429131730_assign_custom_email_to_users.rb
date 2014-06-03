class AssignCustomEmailToUsers < ActiveRecord::Migration
  def change
    User.all.map do |user|
      unless user.custom_email
        user.create_custom_email
      end
    end
  end
end
