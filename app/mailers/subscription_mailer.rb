class SubscriptionMailer < ApplicationMailer
  default from: 'inscriptions@wetennis.fr'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.confirmation.subject
  #
  def confirmation(subscriptions)
    @subscriptions = subscriptions
    binding.pry

    mail to: @subscriptions.first.user.email, subject: "Inscription Envoyée"
  end

   def confirmation_judge(subscriptions)
    @subscriptions = subscriptions

    mail to: @subscriptions.first.tournament.user.email, subject: "Nouvelle demande d'Inscription à #{@subscriptions.first.tournament.name}"
  end

  def confirmation_invited_user(subscription)
    @subscription = subscription
    mail to: @subscription.user.email, subject: "#{@subscription.tournament.user.full_name}, juge-arbitre de #{@subscription.tournament.name} vous a ajouté à ce Tournoi dans la catégorie #{@subscription.competition.category}"
  end

  def confirmed(subscription)
    @subscription = subscription
    mail to: @subscription.user.email, subject: "Inscription Confirmée"
  end

  def confirmed_warning(subscription)
    @subscription = subscription
    mail to: @subscription.user.email, subject: "Inscription Confirmée mais non réglée"
  end

  def refused(subscription)
    @subscription = subscription
    mail to: @subscription.user.email, subject: "Inscription Refusée"
  end

  def new_subscription(subscriptions)
    @subscriptions = subscriptions
    mail to: "davidgeismar@wetennis.fr", subject: "Nouvelle inscription / paiement pour #{@subscription.first.tournament.name}"
  end
end
