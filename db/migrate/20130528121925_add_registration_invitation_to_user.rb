class AddRegistrationInvitationToUser < ActiveRecord::Migration
  def change
    add_column :users, :registration_invitation_id, :integer
  end
end
