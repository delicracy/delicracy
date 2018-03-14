class RenameTableOffersToOrders < ActiveRecord::Migration[5.1]
  def change
    rename_table :orders, :offers
  end
end
