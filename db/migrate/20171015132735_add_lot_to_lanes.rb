class AddLotToLanes < ActiveRecord::Migration[5.1]
  def change
    add_column :lanes, :lot, :decimal
  end
end
