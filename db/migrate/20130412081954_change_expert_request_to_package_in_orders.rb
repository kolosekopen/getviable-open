class ChangeExpertRequestToPackageInOrders < ActiveRecord::Migration
  def change
  	rename_column :orders, :expert_request_id, :package_id
  	rename_column :orders, :expert_request_code, :package_code
  end
end
