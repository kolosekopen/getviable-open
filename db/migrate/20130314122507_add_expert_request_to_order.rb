class AddExpertRequestToOrder < ActiveRecord::Migration
  def change
  	add_column :orders, :expert_request_id, :integer
  end
end
