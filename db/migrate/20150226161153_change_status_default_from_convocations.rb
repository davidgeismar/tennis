class ChangeStatusDefaultFromConvocations < ActiveRecord::Migration
 def up
    change_column_default :convocations, :status, "pending"
  end

  def down
    change_column_default :convocations, :status, nil
  end
end
