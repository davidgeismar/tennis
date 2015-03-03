class UsersController < ApplicationController
  before_action :set_user
  before_action :load_activities, only: [:show]

  def show

  end

  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path(current_user)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :name, :licence_number, :date_of_birth, :genre, :email, :ranking, :judge_number, :telephone, :picture)
  end

  def set_user
    @user = User.find(params[:id])
    authorize @user

  end

  def load_activities
  @activities = PublicActivity::Activity.order('created_at DESC').limit(5)
  end

end
