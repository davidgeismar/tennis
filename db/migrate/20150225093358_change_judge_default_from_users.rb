class ChangeJudgeDefaultFromUsers < ActiveRecord::Migration
  def up
    change_column_default :users, :judge, false
  end

  def down
    change_column_default :users, :judge, nil
  end
end
