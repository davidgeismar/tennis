class AddFundsReceivedToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :funds_received, :boolean, default: false
  end
end
