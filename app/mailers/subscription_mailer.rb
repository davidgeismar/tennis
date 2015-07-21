class SubscriptionMailer < ApplicationMailer
  default from: 'contactl@WeTennis.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.confirmation.subject
  #
  def confirmation(subscription)
    @subscription = subscription

    mail to: @subscription.user.email, subject: "Inscription Envoyée"
  end

  def confirmation_invited_user(subscription)
    @subscription = subscription
    mail to: @subscription.user.email, subject: "#{@subscription.tournament.user.full_name}, juge-arbitre de #{@subscription.tournament.name} vous a ajouté au Tournoi"
  end

  def confirmed(subscription)
    @subscription = subscription
    mail to: @subscription.user.email, subject: "Inscription Confirmée"
  end

  def refused(subscription)
    @subscription = subscription
    mail to: @subscription.user.email, subject: "Inscription Refusée"
  end
end
