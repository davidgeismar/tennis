class UsersController < ApplicationController
  def show
    @user = current_user
    authorize @user
  end

  def edit
    @user = current_user
    authorize @user
  end

  def update
    @user = current_user
    @user.update(user_params)
    authorize @user
    redirect_to user_path
  end



  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :licence_number, :date_of_birth, :genre, :email, :ranking, :judge_number, :picture)
  end

end
