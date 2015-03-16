class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :conversation, index: true
      t.references :user, index: true
      t.datetime :read_at
      t.text :content

      t.timestamps null: false
    end
  end
end
