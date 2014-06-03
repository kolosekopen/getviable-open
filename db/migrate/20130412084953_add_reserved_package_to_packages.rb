class AddReservedPackageToPackages < ActiveRecord::Migration
  def change
  	add_column :packages, :reserved_package, :integer
  end
end
