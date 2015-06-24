class UsersController < ApplicationController
  skip_after_action :verify_authorized, only: [:set_user]
  before_action :set_user

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else

      render 'edit'
    end
  end

  # called when user pays for subscription
  def update_card
    authorize @user
    @user.update(card_params)
    render nothing: true
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :licence_number, :genre, :email, :ranking, :judge_number, :telephone, :picture, :licencepicture, :certifmedpicture, :card_id, :birthdate, :club, :iban, :bic, :address, :login_aei, :password_aei)
  end

  def card_params
    params.require(:user).permit(:card_id)
  end

  def set_user
    @user = User.find(params[:id])
    # authorize @user
  end
end
