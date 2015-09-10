class AddCompetitionToSubscription < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :competition, index: true, foreign_key: true
  end
end
