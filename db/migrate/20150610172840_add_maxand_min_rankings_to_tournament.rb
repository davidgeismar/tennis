class AddMaxandMinRankingsToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :min_ranking, :string
    add_column :tournaments, :max_ranking, :string
  end
end
