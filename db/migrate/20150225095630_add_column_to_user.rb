class AddColumnToUser < ActiveRecord::Migration
  def change
     add_column :users, :judge_number, :integer
  end
end
