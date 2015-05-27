class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.string :content
      t.timestamps null: false
    end
    add_foreign_key :subscriptions, :users
  end
end
