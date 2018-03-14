class CreateTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :transactions do |t|
      t.string :type
      t.decimal :amount
      t.references :user, foreign_key: true
      t.references :lane, foreign_key: true

      t.timestamps
    end
  end
end
