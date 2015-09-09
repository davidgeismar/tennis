class AddTotalToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :total, :boolean, default: true
  end
end
