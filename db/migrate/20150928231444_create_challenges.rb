class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.date :date
      t.time :time
      t.text :place
      t.text :score
      t.integer :winner
      t.integer :loser
      t.integer :referee

      t.timestamps null: false
    end
  end
end
