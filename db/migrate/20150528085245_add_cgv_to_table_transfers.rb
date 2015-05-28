class AddCgvToTableTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :cgv, :boolean
  end
end
