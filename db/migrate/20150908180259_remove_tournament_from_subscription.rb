class RemoveTournamentFromSubscription < ActiveRecord::Migration
  def up
    remove_foreign_key :subscriptions, :tournaments
    remove_reference :subscriptions, :tournament, index: true
  end

  def down
    add_reference :subscriptions, :tournament, index: true
    add_foreign_key :subscriptions, :tournaments
  end
end
