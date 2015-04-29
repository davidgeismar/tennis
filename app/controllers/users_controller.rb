class UsersController < ApplicationController
  skip_after_action :verify_authorized, only: [:set_user, :update_card, :update, :show, :edit]
  before_action :set_user

  def show

  end

  def edit
  end

  def update
    # @user.update(user_params)
    create_mangopay_natural_user_and_wallet
    raise
    redirect_to user_path(current_user)
  end

  def update_card
    @user.update(card_params)
    # puts card_params.to_s
    # puts @user.id.to_s
    render nothing: true
    # redirect_to user_path(current_user)
    # redirect_to :controller => "users", :action =>"show", :id => current_user.id, :method =>:get
  end
  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :licence_number, :date_of_birth, :genre, :email, :ranking, :judge_number, :telephone, :picture, :licencepicture, :certifmedpicture, :card_id)
  end

  def card_params
    params.require(:user).permit(:card_id)
  end

  def set_user
    @user = User.find(params[:id])
    # authorize @user
  end



   def create_mangopay_natural_user_and_wallet
    natural_user = MangoPay::NaturalUser.create(mangopay_user_attributes)


    wallet = MangoPay::Wallet.create({
      Owners: [natural_user["Id"]],
      Description: "My first wallet",
      Currency: "EUR",
      })

    kyc_document = MangoPay::KycDocument.create(natural_user["Id"],{Type: "IDENTITY_PROOF", Tag: "Driving Licence"})

    current_user.mangopay_natural_user_id= natural_user["Id"]
    current_user.wallet_id = wallet["Id"]
    current_user.kyc_document_id = kyc_document["Id"]
    current_user.save
  end

  def mangopay_user_attributes
    {
      'Email' => current_user.email,
      'FirstName' => current_user.first_name,
      'LastName' => current_user.last_name,  # TODO: Change this! Add 2 columns on users table.
      'Birthday' => current_user.date_of_birth.to_i,  # TODO: Change this! Add 1 column on users table
      'Nationality' => 'FR',  # TODO: change this!
      'CountryOfResidence' => 'FR' # TODO: change this!
    }
  end

end
