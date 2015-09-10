class AddSubscriptionReferenceToTransfers < ActiveRecord::Migration
  def change
    add_reference :transfers, :subscription, index: true, foreign_key: true
  end
end
