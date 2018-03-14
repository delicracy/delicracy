class AddStatusToRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :races, :status, :integer, default: 0
  end
end
