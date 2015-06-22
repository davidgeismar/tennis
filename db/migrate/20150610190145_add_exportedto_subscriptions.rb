class AddExportedtoSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :exported, :boolean, default: false
  end
end
