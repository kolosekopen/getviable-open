class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :idea_id
      t.string :code
      t.integer :package

      t.timestamps
    end

    add_index :packages, :idea_id
    add_index :packages, :code
  end
end
