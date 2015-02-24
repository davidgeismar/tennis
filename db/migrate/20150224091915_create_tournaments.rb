class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.references :user, index: true
      t.string :genre
      t.string :category
      t.boolean :accepted
      t.integer :amount
      t.date :starts_on
      t.date :ends_on

      t.timestamps null: false
    end
    add_foreign_key :tournaments, :users
  end
end
