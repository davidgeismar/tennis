class AddCompetitionToNotification < ActiveRecord::Migration
  def change
    add_reference :notifications, :competition, index: true, foreign_key: true
  end
end
