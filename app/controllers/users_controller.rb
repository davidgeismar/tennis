class UsersController < ApplicationController
  skip_after_action :verify_authorized, only: [:set_user, :update_card, :update, :edit, :show]
  before_action :set_user

  def show

  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(current_user)
    else
      render 'edit'
    end
  end

  def update_notifications
    current_user.notifications.each do |notification|
      notification.read == true
      notification.save
    end
    render nothing: true
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
    params.require(:user).permit(:first_name, :last_name, :name, :licence_number, :genre, :email, :ranking, :judge_number, :telephone, :picture, :licencepicture, :certifmedpicture, :card_id, :birthdate, :club, :iban, :bic, :address)
  end

  def card_params
    params.require(:user).permit(:card_id)
  end

  def set_user
    @user = User.find(params[:id])
    # authorize @user
  end




end
