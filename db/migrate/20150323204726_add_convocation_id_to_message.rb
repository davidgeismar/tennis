class AddConvocationIdToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :convocation_id, :integer
  end
end
