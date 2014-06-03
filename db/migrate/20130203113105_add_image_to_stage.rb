class AddImageToStage < ActiveRecord::Migration
  def change
    add_column :stages, :image, :string
  end
end
