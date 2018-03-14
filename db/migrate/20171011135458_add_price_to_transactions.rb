class AddPriceToTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :price, :decimal
  end
end
