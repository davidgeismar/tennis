class AddMangopayPayinIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :mangopay_payin_id, :string
  end
end
