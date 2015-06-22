class TournamentMailer < ApplicationMailer
  default from: 'contact@tennismatch.com'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.tournament_mailer.accepted.subject
  #
  def accepted(tournament)

     @tournament = tournament

    mail(to: tournament.user.email, subject: 'Tournoi Accepté')

  end
end
