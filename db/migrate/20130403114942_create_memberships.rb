class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user, :group
      
      t.timestamps
    end
  end
end
