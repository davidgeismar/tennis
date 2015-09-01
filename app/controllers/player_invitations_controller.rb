class PlayerInvitationsController < ApplicationController
  before_action :set_tournament

  def new
  end

  def create
    if params[:first_name] == ""
      flash[:alert] = "Merci de préciser un prénom"
      render :new
    elsif params[:last_name] == ""
      flash[:alert] = "Merci de préciser un nom"
      render :new
    elsif params[:licence_number] == ""

      flash[:alert] = "Merci de préciser un numéro de licence valide"
      render :new
    elsif params[:email] == ""
    end
      # email must be present in the parameter hash if it is not invitation is not sent
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

        @errors = []
        @user.errors.messages.each do |key, value|
          error = key.to_s + ' ' + value.join
          @errors << error
        end
        render :new
      end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
    custom_authorize PlayerInvitationPolicy, @tournament
  end
end
