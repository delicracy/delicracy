class RenameAmountToVolumeToOffers < ActiveRecord::Migration[5.1]
  def change
    rename_column :offers, :amount, :volume
  end
end
