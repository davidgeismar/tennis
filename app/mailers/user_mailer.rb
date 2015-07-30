class UserMailer < ApplicationMailer
  default from: 'contact@wetennis.fr'

  def welcome(user)
    @user = user  # Instance variable => available in view

    mail(to: @user.email, subject: 'Bienvenu sur wetennis.fr')
    # This will render a view in `app/views/user_mailer`!
  end

  def welcome_judge(user)
    @user = user  # Instance variable => available in view

    mail(to: @user.email, subject: 'Bienvenu sur wetennis.fr')
    # This will render a view in `app/views/user_mailer`!
  end
end
