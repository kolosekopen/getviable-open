class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.belongs_to :invitable, polymorphic: true
      t.string :token
      t.integer :user_id
      t.integer :invitee_id
      t.string :invitee_email
      t.integer :invitee_role_id
      t.boolean :active, :default => true

      t.timestamps
    end
    add_index :invitations, [:invitable_id, :invitable_type]
  end
end
