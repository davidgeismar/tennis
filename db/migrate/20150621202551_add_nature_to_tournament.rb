class AddNatureToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :nature, :string, default: "single"
  end
end
