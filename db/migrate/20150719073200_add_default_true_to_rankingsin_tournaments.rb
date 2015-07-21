class AddDefaultTrueToRankingsinTournaments < ActiveRecord::Migration
  def up
    change_column :tournaments, :NC, :boolean, default: true
    # change_column :tournaments, :quarante, :boolean, default: true
    change_column :tournaments, :trentecinq, :boolean, default: true
    change_column :tournaments, :trentequatre, :boolean, default: true
    change_column :tournaments, :trentetrois, :boolean, default: true
    change_column :tournaments, :trentedeux, :boolean, default: true
    change_column :tournaments, :trenteun, :boolean, default: true
    change_column :tournaments, :trente, :boolean, default: true
    change_column :tournaments, :quinzecinq, :boolean, default: true
    change_column :tournaments, :quinzequatre, :boolean, default: true
    change_column :tournaments, :quinzetrois, :boolean, default: true
    change_column :tournaments, :quinzedeux, :boolean, default: true
    change_column :tournaments, :quinzeun, :boolean, default: true
    change_column :tournaments, :quinze, :boolean, default: true
    change_column :tournaments, :cinqsix, :boolean, default: true
    change_column :tournaments, :quatresix, :boolean, default: true
    change_column :tournaments, :troissix, :boolean, default: true
    change_column :tournaments, :deuxsix, :boolean, default: true
    change_column :tournaments, :unsix, :boolean, default: true
    change_column :tournaments, :zero, :boolean, default: true
    change_column :tournaments, :moinsdeuxsix, :boolean, default: true
    change_column :tournaments, :moinsquatresix, :boolean, default: true
    change_column :tournaments, :moinsquinze, :boolean, default: true
    change_column :tournaments, :moinstrente, :boolean, default: true

  end
  def down
    change_column :tournaments, :NC, :boolean, default: nil
    # change_column :tournaments, :quarante, :boolean, default: nil
    change_column :tournaments, :trentecinq, :boolean, default: nil
    change_column :tournaments, :trentequatre, :boolean, default: nil
    change_column :tournaments, :trentetrois, :boolean, default: nil
    change_column :tournaments, :trentedeux, :boolean, default: nil
    change_column :tournaments, :trenteun, :boolean, default: nil
    change_column :tournaments, :trente, :boolean, default: nil
    change_column :tournaments, :quinzecinq, :boolean, default: nil
    change_column :tournaments, :quinzequatre, :boolean, default: nil
    change_column :tournaments, :quinzetrois, :boolean, default: nil
    change_column :tournaments, :quinzedeux, :boolean, default: nil
    change_column :tournaments, :quinzeun, :boolean, default: nil
    change_column :tournaments, :quinze, :boolean, default: nil
    change_column :tournaments, :cinqsix, :boolean, default: nil
    change_column :tournaments, :quatresix, :boolean, default: nil
    change_column :tournaments, :troissix, :boolean, default: nil
    change_column :tournaments, :deuxsix, :boolean, default: nil
    change_column :tournaments, :unsix, :boolean, default: nil
    change_column :tournaments, :zero, :boolean, default: nil
    change_column :tournaments, :moinsdeuxsix, :boolean, default: nil
    change_column :tournaments, :moinsquatresix, :boolean, default: nil
    change_column :tournaments, :moinsquinze, :boolean, default: nil
    change_column :tournaments, :moinstrente, :boolean, default: nil

  end
end
