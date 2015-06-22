class CreateDisponibilities < ActiveRecord::Migration
  def change
    create_table :disponibilities do |t|
      t.references :subscription, index: true
      t.string :week
      t.string :saturday
      t.string :sunday

      t.timestamps null: false
    end
    add_foreign_key :disponibilities, :subscriptions
  end
end
