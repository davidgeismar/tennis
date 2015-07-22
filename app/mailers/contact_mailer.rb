class ContactMailer < ApplicationMailer
  default from: 'contact@tennis-match.fr'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.convocation_mailer.convocation.subject
  #
  def send_message_to_wetennis(contact)
    @contact = contact

    mail(to: 'davidgeismar@hotmail.fr', subject: "Message de #{@contact.email}")
  end

  def confirmation_email(contact)
    @contact = contact

    mail(to: @contact.email, subject: "Votre message a bien été envoyé")
  end
end