class RemoveMointrenteFromTournament < ActiveRecord::Migration
  def change
    remove_column :tournaments, :moinstrente
  end
end
