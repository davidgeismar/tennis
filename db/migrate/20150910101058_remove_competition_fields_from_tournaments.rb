class RemoveCompetitionFieldsFromTournaments < ActiveRecord::Migration
  def change
    remove_column :tournaments,  :category, :string
    remove_column :tournaments,  :min_ranking, :string
    remove_column :tournaments,  :max_ranking, :string
    remove_column :tournaments,  :nature, :string
    remove_column :tournaments,  :genre, :string
    remove_column :tournaments,  :quarante, :boolean, default: true
    remove_column :tournaments,  :NC, :boolean, default: true
    remove_column :tournaments,  :trentecinq, :boolean, default: true
    remove_column :tournaments,  :trentequatre, :boolean, default: true
    remove_column :tournaments,  :trentetrois, :boolean, default: true
    remove_column :tournaments,  :trentedeux, :boolean, default: true
    remove_column :tournaments,  :trenteun, :boolean, default: true
    remove_column :tournaments,  :trente, :boolean, default: true
    remove_column :tournaments,  :quinzecinq, :boolean, default: true
    remove_column :tournaments,  :quinzequatre, :boolean, default: true
    remove_column :tournaments,  :quinzetrois, :boolean, default: true
    remove_column :tournaments,  :quinzedeux, :boolean, default: true
    remove_column :tournaments,  :quinzeun, :boolean, default: true
    remove_column :tournaments,  :quinze, :boolean, default: true
    remove_column :tournaments,  :cinqsix, :boolean, default: true
    remove_column :tournaments,  :quatresix, :boolean, default: true
    remove_column :tournaments,  :troissix, :boolean, default: true
    remove_column :tournaments,  :deuxsix, :boolean, default: true
    remove_column :tournaments,  :unsix, :boolean, default: true
    remove_column :tournaments,  :zero, :boolean, default: true
    remove_column :tournaments,  :moinsdeuxsix, :boolean, default: true
    remove_column :tournaments,  :moinsquatresix, :boolean, default: true
    remove_column :tournaments,  :moinsquinze, :boolean, default: true
    remove_column :tournaments,  :total, :boolean, default: true
  end
end
