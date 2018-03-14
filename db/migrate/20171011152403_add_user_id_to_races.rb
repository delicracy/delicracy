class AddUserIdToRaces < ActiveRecord::Migration[5.1]
  def change
    add_reference :races, :user, foreign_key: true
  end
end
