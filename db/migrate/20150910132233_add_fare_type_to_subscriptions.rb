class AddFareTypeToSubscriptions < ActiveRecord::Migration
  def change
    add_column  :subscriptions, :fare_type, :string
    add_index   :subscriptions, :fare_type
  end
end
