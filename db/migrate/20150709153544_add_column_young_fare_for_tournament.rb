class AddColumnYoungFareForTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :young_fare, :integer
  end
end
