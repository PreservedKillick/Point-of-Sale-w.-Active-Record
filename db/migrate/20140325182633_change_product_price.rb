class ChangeProductPrice < ActiveRecord::Migration
  def change
    remove_column :products, :price, :decimal
    add_column :products, :price, :decimal, precision: 4, scale: 2
  end
end
