class AddTournamentToSubscriptions < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :tournament, index: true, foreign_key: true
  end
end
