class ConvocationMailer < ApplicationMailer
  default from: 'convocations@wetennis.fr'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.convocation_mailer.convocation.subject
  #
  def send_convocation(convocation)
    @convocation = convocation

    mail(to: @convocation.subscription.user.email, subject: "Convocation au tournoi #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category} pour le #{@convocation.date.strftime("%d/%m/%Y")} à #{@convocation.hour.strftime("%Hh%M")}")
  end

  def convocation_confirmed_by_judge(convocation)
    @convocation = convocation

    mail(to: @convocation.subscription.user.email, subject: "Convocation au tournoi #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category} pour le #{@convocation.date.strftime("%d/%m/%Y")} à #{@convocation.hour.strftime("%Hh%M")}")
  end

  def convocation_confirmed_by_player(convocation)
    @convocation  = convocation
    @judge        = @convocation.subscription.tournament.user

    mail(to: @convocation.subscription.tournament.user.email, subject: "#{@convocation.subscription.user.full_name} confirme sa présence pour la convocation au tournoi #{@convocation.subscription.tournament.name} dans la catégorie #{@convocation.subscription.competition.category} pour le #{@convocation.date.strftime("%d/%m/%Y")} à #{@convocation.hour.strftime("%Hh%M")}")
  end
end
