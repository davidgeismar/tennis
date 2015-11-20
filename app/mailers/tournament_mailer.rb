class TournamentMailer < ApplicationMailer
  default from: 'Wetennis<contact@wetennis.fr>'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tournament_mailer.accepted.subject
  #

  def accepted(tournament)
     @tournament = tournament

    mail(to: tournament.user.email, subject: 'Tournoi Accepté')
  end

  def created(tournament)
    @tournament = tournament
    mail(to: "davidgeismar@wetennis.fr", subject: "Tournoi créee, en attente de validation")
  end

  def edited(tournament)
    @tournament = tournament
    mail(to: "davidgeismar@wetennis.fr", subject: "Tournoi modifié, en attente de validation")
  end
end
