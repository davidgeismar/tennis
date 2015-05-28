class AddConvocationIdToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :convocation_id, :integer
  end
end
