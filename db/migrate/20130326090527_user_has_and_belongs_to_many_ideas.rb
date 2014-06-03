class UserHasAndBelongsToManyIdeas < ActiveRecord::Migration
  def self.up
    create_table :ideas_users do |t|
      t.references :idea, :user
      t.integer :role_id
    end
  end

  def self.down
    drop_table :ideas_users
  end
end
