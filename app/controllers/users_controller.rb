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
    if @user.subscriptions.exists? && !@user.judge? && user_params[:birthdate].present?
      flash[:alert] = "Vous ne pouvez plus modifier votre date de naissance après vous etre inscrit à une compétition. Merci de contacter l'administrateur du site"
      redirect_to user_path(current_user)
    elsif @user.update(user_params)
      redirect_to user_path(current_user)
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :address,
      :birthdate,
      :certifmedpicture,
      :club,
      :email,
      :first_name,
      :genre,
      :judge_number,
      :last_name,
      :licence_number,
      :licencepicture,
      :login_aei,
      :name,
      :password_aei,
      :picture,
      :ranking,
      :telephone,
      :sms_forfait,
      :sms_quantity
    )
  end

  def set_user
    @user = User.find(params[:id])
    # authorize @user
  end
end
