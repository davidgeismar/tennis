class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.references :subscription, index: true
      t.string :status
      t.integer :mangopay_transaction_id
      t.string :category
      t.json :archive

      t.timestamps null: false
    end
    add_foreign_key :transfers, :subscriptions
  end
end
