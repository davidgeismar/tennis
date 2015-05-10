class ConvocationMailer < ApplicationMailer
  default from: 'your-email@example.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.convocation_mailer.convocation.subject
  #
  def create(convocation)
    @convocation = convocation

    mail(to: @user.email, subject: 'convocation')
  end
end
