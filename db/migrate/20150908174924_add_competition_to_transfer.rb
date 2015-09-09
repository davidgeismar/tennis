class AddCompetitionToTransfer < ActiveRecord::Migration
  def change
    add_reference :transfers, :competition, index: true, foreign_key: true
  end
end
