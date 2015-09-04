class PlayerInvitationsController < ApplicationController
  before_action :set_tournament

  def new
  end

  def create
    @errors = []
    if params[:first_name] == ""
      @errors << "Merci de préciser le prénom du licencié"
      render :new and return
    elsif params[:last_name] == ""
      @errors << "Merci de préciser le nom du licencié"
      render :new and return
    elsif (params[:licence_number].delete(' ') =~ /\A\d{7}\D{1}\z/).nil?
      @errors << "Merci de préciser un numéro de licence valide"
      render :new and return
    else
      # email must be present in the parameter hash if it is not invitation is not sent
      @user = User.invite!(email: params[:email], name: "#{params[:first_name]} #{params[:last_name]}")
      @user.first_name      = params[:first_name]
      @user.last_name       = params[:last_name]
      @user.licence_number  = params[:licence_number].delete(' ')
      @user.save
      @subscription = Subscription.new(user: @user, tournament: @tournament)
      if @subscription.save
        SubscriptionMailer.confirmation_invited_user(@subscription).deliver
        redirect_to tournament_subscriptions_path(@tournament)
      else
        render :new
      end
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
    custom_authorize PlayerInvitationPolicy, @tournament
  end
end
