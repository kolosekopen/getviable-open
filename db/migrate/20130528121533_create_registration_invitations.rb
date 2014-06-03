class CreateRegistrationInvitations < ActiveRecord::Migration
  def change
    create_table :registration_invitations do |t|
      t.string :sent_to
      t.string :token
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
