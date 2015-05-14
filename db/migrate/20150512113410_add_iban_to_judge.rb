class AddIbanToJudge < ActiveRecord::Migration
  def change
    add_column :users, :iban, :string
  end
end
