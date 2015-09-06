class AddSmsQuantityToUsers < ActiveRecord::Migration
  def change
     add_column :users, :sms_quantity, :integer
  end
end
