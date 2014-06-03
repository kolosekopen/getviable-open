class AddPromoCodeToPackages < ActiveRecord::Migration
  def change
  	add_column :packages, :promo_code, :string
  end
end
