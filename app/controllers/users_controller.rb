class UsersController < ApplicationController
  skip_after_action :verify_authorized, only: [:set_user]
  before_action :set_user, except: [:index]

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

  def index
    @users = User.all
    policy_scope(@users)
    @users = User.near(request.location, 20, :units => :km).where(ranking: current_user.ranking)
  end

  private

  def user_params
    params.require(:user).permit(
      :extradoc,
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
