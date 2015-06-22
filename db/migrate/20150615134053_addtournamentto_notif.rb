class AddtournamenttoNotif < ActiveRecord::Migration
  def change
      add_column :notifications, :tournament_id, :integer
  end
end
