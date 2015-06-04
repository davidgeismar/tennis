class SubscriptionMailer < ApplicationMailer
  default from: 'contactl@tennismatch.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.confirmation.subject
  #
  def confirmation(subscription)
    @subscription = subscription

    mail to: @subscription.user, subject: "Inscription Envoyée"
  end
end
