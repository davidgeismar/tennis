class ConvocationMailer < ApplicationMailer
  default from: 'convocations@wetennis.fr'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.convocation_mailer.convocation.subject
  #
  def send_convocation(convocation)
    @convocation = convocation

    mail(to: @convocation.subscription.user.email, subject: "Convocation au tournoi #{@convocation.subscription.tournament.name} pour le #{@convocation.date} à  #{@convocation.hour}")
  end
end
