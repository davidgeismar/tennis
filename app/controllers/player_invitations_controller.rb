class PlayerInvitationsController < ApplicationController
  before_action :set_competition

  def new
  end

  def create
    emails_in_competition = @competition.subscriptions.map {|subscription| subscription.user.email}

    if params[:first_name] == ""
      flash[:alert] = "Merci de préciser le prénom du licencié"
      return render :new
    elsif params[:last_name] == ""
      flash[:alert] = "Merci de préciser le nom du licencié"
      return render :new
    elsif (params[:licence_number].delete(' ') =~ /\A\d{7}\D{1}\z/).nil?
      flash[:alert] = "Merci de préciser un numéro de licence valide"
      return render :new
    # if user est déjà inscrit au tournoi
    elsif emails_in_competition.include?(params[:email])
      flash[:alert] = "Ce licencié a déjà été ajouté au tournoi. Merci de vérifier votre liste de joueur"
      redirect_to competition_subscriptions_path(@competition)
      #if user n'est pas déjà inscrit sur wetennis
    elsif User.find_by_email(params[:email]).nil?
      # email must be present in the parameter hash if it is not invitation is not sent
        @user = User.invite!(email: params[:email], name: "#{params[:first_name]} #{params[:last_name]}")
        @user.first_name      = params[:first_name]
        @user.last_name       = params[:last_name]
        @user.licence_number  = params[:licence_number].delete(' ')
        @user.save
        @subscription = Subscription.new(user: @user, competition: @competition, fare_type: :unknown)
        if @subscription.save
          SubscriptionMailer.confirmation_invited_user(@subscription).deliver
          flash[:notice] = "Ce licencié a bien été ajouté aux inscrits. N'oublié pas confirmer (ou de refuser) le statut de son inscription."
          redirect_to competition_subscriptions_path(@competition)
        else
          # n'arrivera pas car toute les erreurs sont déjà géré
          render :new
        end
    else
        #mail proposant au user de s'inscrire au tournoi via wetennis
        PlayerInvitationsMailer.send_invitation(@competition, params[:email]).deliver
        flash[:notice] = "Ce joueur a déjà un compte sur WeTennis, un mail lui a été envoyé pour lui demander de s'inscrire au tournoi"
        redirect_to competition_subscriptions_path(@competition)
    end
  end

  private

  def set_competition
    @competition = Competition.find(params[:competition_id])
    custom_authorize PlayerInvitationPolicy, @competition
  end
end
