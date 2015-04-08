class AddMangopayNaturalUserWalletKycDocumentAndCardToUser < ActiveRecord::Migration
  def change
    add_column :users, :mangopay_natural_user_id, :integer
    add_column :users, :wallet_id, :integer
    add_column :users, :kyc_document_id, :integer
    add_column :users, :card_id, :integer
  end
end
