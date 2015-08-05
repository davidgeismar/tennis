class AddDefaultToAccepted < ActiveRecord::Migration
  def up
    change_column :tournaments, :accepted, :boolean, default: false
  end

  def down
    change_column :tournaments, :accepted, :boolean, default: nil
  end
end
