class RenameTransactionToOrders < ActiveRecord::Migration[5.1]
  def change
    rename_table :transactions, :orders
  end
end
