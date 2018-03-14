class CreateOperators < ActiveRecord::Migration[5.1]
  def change
    create_table :operators do |t|
      t.integer :host_id
      t.integer :oracle_id

      t.timestamps
    end
    add_index :operators, :host_id
    add_index :operators, :oracle_id
    add_index :operators, [:host_id, :oracle_id]
  end
end
