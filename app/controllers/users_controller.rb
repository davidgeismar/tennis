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
    if @user.subscriptions.exists? && !@user.judge? && user_params[:birthdate].present?
      flash[:alert] = "Vous ne pouvez plus modifier votre date de naissance après vous etre inscrit à une compétition. Merci de contacter l'administrateur du site"
      redirect_to user_path(current_user)
    elsif @user.update(user_params)
      if @user.judge? && @user.profile_complete? && !@user.accepted
        UserMailer.judge_waiting_for_confirmation(@user).deliver
        redirect_to user_path(current_user)
      elsif params[:user][:tournament].present?
        flash[:notice] = "Vous pouvez maintenant renseigner vos disponibilités pour le tournoi #{Tournament.find(params[:user][:tournament]).name}"
        redirect_to new_tournament_disponibility_path(params[:user][:tournament])
      else
        redirect_to user_path(current_user)
      end
    else
      render 'edit'
    end
  end

  def index

    @users = User.all
    @challenge = Challenge.new

    @users = User.near(request.location, 20, :units => :km)
    policy_scope(@users)
    # @users = User.near(request.location, 20, :units => :km).where(ranking: current_user.ranking)
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
      :sms_quantity,
      :tournament
    )
  end

  def set_user
    @user = User.find(params[:id])
    # authorize @user
  end
end
