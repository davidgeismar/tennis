class AddRankingsToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :quarante, :boolean, default: true
    add_column :competitions, :NC, :boolean, default: true
    add_column :competitions, :trentecinq, :boolean, default: true
    add_column :competitions, :trentequatre, :boolean, default: true
    add_column :competitions, :trentetrois, :boolean, default: true
    add_column :competitions, :trentedeux, :boolean, default: true
    add_column :competitions, :trenteun, :boolean, default: true
    add_column :competitions, :trente, :boolean, default: true
    add_column :competitions, :quinzecinq, :boolean, default: true
    add_column :competitions, :quinzequatre, :boolean, default: true
    add_column :competitions, :quinzetrois, :boolean, default: true
    add_column :competitions, :quinzedeux, :boolean, default: true
    add_column :competitions, :quinzeun, :boolean, default: true
    add_column :competitions, :quinze, :boolean, default: true
    add_column :competitions, :cinqsix, :boolean, default: true
    add_column :competitions, :quatresix, :boolean, default: true
    add_column :competitions, :troissix, :boolean, default: true
    add_column :competitions, :deuxsix, :boolean, default: true
    add_column :competitions, :unsix, :boolean, default: true
    add_column :competitions, :zero, :boolean, default: true
    add_column :competitions, :moinsdeuxsix, :boolean, default: true
    add_column :competitions, :moinsquatresix, :boolean, default: true
    add_column :competitions, :moinsquinze, :boolean, default: true
    add_column :competitions, :premiereserie, :boolean, default: true
  end
end
