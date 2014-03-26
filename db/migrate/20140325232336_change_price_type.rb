class ChangePriceType < ActiveRecord::Migration
  def change
    remove_column :products, :price, :decimal
    add_column :products, :price, :decimal, precision: 5, scale: 2
  end
end
