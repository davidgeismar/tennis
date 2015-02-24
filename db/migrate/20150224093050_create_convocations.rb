class CreateConvocations < ActiveRecord::Migration
  def change
    create_table :convocations do |t|
      t.date :date
      t.time :hour
      t.references :subscription, index: true
      t.string :status

      t.timestamps null: false
    end
    add_foreign_key :convocations, :subscriptions
  end
end
