class AddClubEmailAndMangopayFieldsToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :club_email,               :string
    add_column :tournaments, :mangopay_user_id,         :string
    add_column :tournaments, :mangopay_wallet_id,       :string
    add_column :tournaments, :mangopay_bank_account_id, :string
  end
end
