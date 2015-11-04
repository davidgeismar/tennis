class UserMailer < ApplicationMailer
  default from: 'contact@wetennis.fr'

  def welcome(user)
    @user = user  # Instance variable => available in view

    mail(to: @user.email, subject: 'Bienvenue sur wetennis.fr')
    # This will render a view in `app/views/user_mailer`!
  end

  def welcome_judge(user)
    @user = user  # Instance variable => available in view

    mail(to: @user.email, subject: 'Bienvenue sur wetennis.fr')
    # This will render a view in `app/views/user_mailer`!
  end

  def new_judge(user)
    @user = user
    mail(to: "davidgeismar@wetennis.fr", subject: 'Nouvelle inscription juge arbitre')
  end

  def judge_waiting_for_confirmation(user)
    @user = user
    mail(to: "davidgeismar@wetennis.fr", subject: 'Profil complet juge arbitre')
  end

  def judge_accepted(user)
    @user = user
    mail(to: @user.email, subject: 'Votre compte Juge Arbitre a été validé')
  end
end
