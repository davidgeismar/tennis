class RemoveSubscriptionFromCompetition < ActiveRecord::Migration
  def up
    remove_foreign_key :competitions, :subscriptions
    remove_reference :competitions, :subscription, index: true
  end

  def down
    add_reference :competitions, :subscription, index: true
    add_foreign_key :competitions, :subscriptions
  end
end
