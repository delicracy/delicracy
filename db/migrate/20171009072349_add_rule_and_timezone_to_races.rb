class AddRuleAndTimezoneToRaces < ActiveRecord::Migration[5.1]
  def change
    add_column :races, :rule, :integer
    add_column :races, :time_zone, :string
  end
end
