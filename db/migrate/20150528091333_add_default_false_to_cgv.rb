class AddDefaultFalseToCgv < ActiveRecord::Migration
  def up
    change_column :transfers, :cgv, :boolean, default: false
  end

  def down
    change_column :transfers, :cgv, :boolean, default: nil
  end
end
