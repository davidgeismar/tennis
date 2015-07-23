class AddIbanAndBicToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :iban, :string
    add_column :tournaments, :bic, :string
  end
end
