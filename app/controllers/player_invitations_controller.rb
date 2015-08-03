class PlayerInvitationsController < ApplicationController
  before_action :set_tournament

  def new
  end

  def create
    @user = User.invite!(email: params[:email], name: "#{params[:first_name]} #{params[:last_name]}")

    @user.first_name      = params[:first_name]
    @user.last_name       = params[:last_name]
    @user.licence_number  = params[:licence_number]
    @user.save

    @subscription = Subscription.new(user: @user, tournament: @tournament)

    if @subscription.save
      SubscriptionMailer.confirmation_invited_user(@subscription).deliver
      redirect_to tournament_subscriptions_path(@tournament)
    else
      render :new
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
    custom_authorize PlayerInvitationPolicy, @tournament
  end
end
