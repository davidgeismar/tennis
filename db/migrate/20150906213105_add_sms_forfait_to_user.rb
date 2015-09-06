class AddSmsForfaitToUser < ActiveRecord::Migration
  def change
    add_column :users, :sms_forfait, :boolean, default: false
  end
end
