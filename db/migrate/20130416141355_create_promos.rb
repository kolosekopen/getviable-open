class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|
      t.string :code
      t.float :discount
      t.datetime :expires
      t.boolean :used

      t.timestamps
    end
  end
end
