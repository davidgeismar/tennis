class SubscriptionsController < ApplicationController
skip_after_action :verify_authorized, only: [:create]
  def index
    @tournament     = Tournament.find(params[:tournament_id])
    @subscriptions  = @tournament.subscriptions
    policy_scope(@subscriptions)
  end

  def update
    @subscription = Subscription.find(params[:id])
    authorize @subscription
    @subscription.update(subscription_params)
    @subscription.create_activity(:update, owner: current_user, recipient: @subscription.user)

    redirect_to tournament_subscriptions_path(@subscription.tournament)

  end

  def show
    @subscription = Subscription.find(params[:id])
    authorize @subscription
  end

  def create
    tournament = Tournament.find(params[:tournament_id])

    if current_user.first_name == "" || current_user.last_name == "" || current_user.licence_number == "" || current_user.telephone == ""
      flash[:alert] = "Vous devez remplir votre profil pour pouvoir vous inscrire à ce tournoi"
      redirect_to tournament_path(tournament)
    else
      @subscription = Subscription.new
      authorize @subscription

      @subscription.tournament = tournament
      @subscription.user = current_user

      if @subscription.save
        @subscription.create_activity(:create, owner: current_user, recipient: tournament.user)
        redirect_to tournament_subscription_path(tournament, @subscription)
      else
        flash[:alert] = "Vous etes déjà inscrit à ce tournoi"
        redirect_to tournament_path(tournament)
      end
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:status)
  end

end
