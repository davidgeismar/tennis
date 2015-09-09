class AddGenreToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :genre, :string
  end
end
