class RenameTypeToSupportTypeExpertRequests < ActiveRecord::Migration
  def change
  	rename_column :expert_requests, :type, :support_type
  end

end
