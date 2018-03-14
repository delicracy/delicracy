class RenameTypeToKindToOffers < ActiveRecord::Migration[5.1]
  def change
    rename_column :offers, :type, :kind
  end
end
