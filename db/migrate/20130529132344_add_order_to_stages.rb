class AddOrderToStages < ActiveRecord::Migration
  def change
    add_column :stages, :order, :integer
  end
end
