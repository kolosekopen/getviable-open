class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.string :title
      t.text :description
      t.string :color

      t.timestamps
    end
  end
end
