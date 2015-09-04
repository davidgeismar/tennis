class PlayerInvitationsMailer < ApplicationMailer
  default from: 'inscription@wetennis.fr'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.convocation_mailer.convocation.subject
  #
  def send_invitation(tournament, user_email)
    @tournament = tournament
    @user_email = user_email

    mail(to: @user_email, subject: "Vous avez été invité à vous inscrire au tournoi #{@tournament.name}")
  end
end
