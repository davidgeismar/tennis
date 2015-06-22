class AddIdentifiantAndLoginAeItoUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_aei, :string
    add_column :users, :password_aei, :string
  end
end
