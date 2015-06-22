class AddHomologationNumberToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :homologation_number, :string
  end
end
