class CreateLicencieffts < ActiveRecord::Migration
  def change
    create_table :licencieffts do |t|
      t.string :first_name
      t.string :last_name
      t.datetime :date_of_birth
      t.string :licence_number
      t.string :genre
      t.string :ranking
      t.string :club

      t.timestamps null: false
    end
  end
end
