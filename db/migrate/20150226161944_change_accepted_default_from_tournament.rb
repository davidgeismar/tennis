class ChangeAcceptedDefaultFromTournament < ActiveRecord::Migration
  def change
    def up
    change_column_default :tournaments, :accepted, false
  end

  def down
    change_column_default :tournaments, :accepted, nil
  end
  end
end
