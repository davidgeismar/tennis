class ChangeStatusDefaultFromSubscriptions < ActiveRecord::Migration
  def up
    change_column_default :subscriptions, :status, "pending"
  end

  def down
    change_column_default :subscriptions, :status, nil
  end
end
