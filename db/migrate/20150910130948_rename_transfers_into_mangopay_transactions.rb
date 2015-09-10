class RenameTransfersIntoMangopayTransactions < ActiveRecord::Migration
  def change
    rename_table :transfers, :mangopay_transactions
  end
end
