class AddRankingsToTournaments < ActiveRecord::Migration
  def change

    add_column :tournaments, :NC, :boolean
    add_column :tournaments, :trentecinq, :boolean
    add_column :tournaments, :trentequatre, :boolean
    add_column :tournaments, :trentetrois, :boolean
    add_column :tournaments, :trentedeux, :boolean
    add_column :tournaments, :trenteun, :boolean
    add_column :tournaments, :trente, :boolean
    add_column :tournaments, :quinzecinq, :boolean
    add_column :tournaments, :quinzequatre, :boolean
    add_column :tournaments, :quinzetrois, :boolean
    add_column :tournaments, :quinzedeux, :boolean
    add_column :tournaments, :quinzeun, :boolean
    add_column :tournaments, :quinze, :boolean
    add_column :tournaments, :cinqsix, :boolean
    add_column :tournaments, :quatresix, :boolean
    add_column :tournaments, :troissix, :boolean
    add_column :tournaments, :deuxsix, :boolean
    add_column :tournaments, :unsix, :boolean
    add_column :tournaments, :zero, :boolean
    add_column :tournaments, :moinsdeuxsix, :boolean
    add_column :tournaments, :moinsquatresix, :boolean
    add_column :tournaments, :moinsquinze, :boolean
    add_column :tournaments, :moinstrente, :boolean

  end
end
