class AddRaceIdToLanes < ActiveRecord::Migration[5.1]
  def change
    add_reference :lanes, :race, foreign_key: true
  end
end
