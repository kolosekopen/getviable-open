class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :express_token
      t.string :express_payer_id
      t.string :first_name
      t.string :last_name
      t.string :ip_address

      t.timestamps
    end
  end
end
