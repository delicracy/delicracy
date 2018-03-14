class AddInitLotToRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :races, :initial_lot, :decimal
  end
end
