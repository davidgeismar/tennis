class AddColumnQuaranteToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :quarante, :boolean, default: true
  end
end
