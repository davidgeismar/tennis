class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.references :tournament, index: true
      t.references :subscription, index: true
      t.string :category
      t.string :min_ranking
      t.string :max_ranking
      t.string :nature

      t.timestamps null: false
    end
    add_foreign_key :competitions, :subscriptions
    add_foreign_key :competitions, :tournaments
  end
end
