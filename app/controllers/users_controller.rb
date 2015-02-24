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
    params.require(:user).permit(:first_name, :last_name, :adresse, :ville, :code_postal, :telephone, :email, :classement, :numéro_de_licence, :année_de_naissance, :nom_club)
  end

end
