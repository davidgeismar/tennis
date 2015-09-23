class AddTournamentToDisponibility < ActiveRecord::Migration
  def change
    add_reference :disponibilities, :tournament, index: true, foreign_key: true
    add_reference :disponibilities, :user, index: true, foreign_key: true
  end
end
