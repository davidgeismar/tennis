class ChangeArchiveFormatInTransfer < ActiveRecord::Migration

  def up
    change_column :transfers, :archive, :hstore
  end

  def down
    change_column :transfers, :archive, :json
  end

end
