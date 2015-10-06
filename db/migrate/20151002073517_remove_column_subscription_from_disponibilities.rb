class RemoveColumnSubscriptionFromDisponibilities < ActiveRecord::Migration
  def change
    remove_column :disponibilities, :subscription_id
  end
end
