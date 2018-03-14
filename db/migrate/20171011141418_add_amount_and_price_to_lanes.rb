class AddAmountAndPriceToLanes < ActiveRecord::Migration[5.1]
  def change
    add_column :lanes, :amount, :decimal
    add_column :lanes, :price, :decimal
  end
end
