class AddfftToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :fft, :boolean
  end
end
