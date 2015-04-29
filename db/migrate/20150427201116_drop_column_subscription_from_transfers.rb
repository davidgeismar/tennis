class DropColumnSubscriptionFromTransfers < ActiveRecord::Migration
  def change
    remove_column :transfers, :subscription_id
  end
end
