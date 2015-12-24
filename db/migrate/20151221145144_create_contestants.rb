class CreateContestants < ActiveRecord::Migration
  def change
    create_table :contestants do |t|
      t.references :user, index: true
      t.references :challenge, index: true

      t.timestamps null: false
    end
      add_foreign_key :contestants, :users
      add_foreign_key :contestants, :challenges
  end
end
