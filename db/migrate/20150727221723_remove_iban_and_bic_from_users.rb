class RemoveIbanAndBicFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :iban,  :string
    remove_column :users, :bic,   :string
  end
end
