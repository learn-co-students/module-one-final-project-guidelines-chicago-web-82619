class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :currency_id
      t.string :name
      t.float :amount
      t.float :price
      t.datetime :date
    end
  end
end
