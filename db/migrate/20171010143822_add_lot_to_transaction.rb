class AddLotToTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :transactions, :lot, :decimal
  end
end
