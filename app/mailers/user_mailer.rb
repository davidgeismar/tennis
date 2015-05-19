class UserMailer < ActionMailer::Base
  default from: 'contact@tennis-match.com'

  def welcome(user)
    @user = user  # Instance variable => available in view

    mail(to: @user.email, subject: 'Welcome to TennisMatch guys')
    # This will render a view in `app/views/user_mailer`!
  end
end
