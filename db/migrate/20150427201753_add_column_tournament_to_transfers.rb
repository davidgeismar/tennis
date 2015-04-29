class AddColumnTournamentToTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :tournament_id, :integer
  end
end
