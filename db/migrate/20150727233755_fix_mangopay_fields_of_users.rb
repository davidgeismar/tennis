class FixMangopayFieldsOfUsers < ActiveRecord::Migration
  def change
    remove_column :users, :bank_account_id,           :integer
    remove_column :users, :client_id,                 :integer
    remove_column :users, :kyc_document_id,           :integer
    remove_column :users, :mangopay_natural_user_id,  :integer
    remove_column :users, :wallet_id,                 :integer

    rename_column :users, :card_id, :mangopay_card_id

    add_column    :users, :mangopay_user_id,          :string
    add_column    :users, :mangopay_wallet_id,        :string
  end
end
