class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :from_currency
      t.string :to_currency
      t.decimal :from_value
      t.decimal :to_value
      t.decimal :rate

      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
