class AddExpertRequestCodeToOrders < ActiveRecord::Migration
  def change
  	add_column :orders, :expert_request_code, :string
  end
end
