class AddFundsSentToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :funds_sent, :boolean, default: false
  end
end
