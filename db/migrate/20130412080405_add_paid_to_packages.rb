class AddPaidToPackages < ActiveRecord::Migration
  def change
  	add_column :packages, :paid, :boolean
  end
end
