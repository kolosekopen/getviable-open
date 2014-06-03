class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :website, :string
    add_column :users, :blog, :string
  end
end
