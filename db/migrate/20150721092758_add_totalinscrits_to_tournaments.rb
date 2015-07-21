class AddTotalinscritsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :total, :boolean, default: true
  end
end
