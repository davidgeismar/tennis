class AeiExportsMailer < ApplicationMailer
  default from: 'contact@wetennis.fr'

  def export_bilan(failure_full_names, already_subscribed_full_names, outdated_licence_full_names, too_young_to_participate_full_names, too_old_to_participate_full_names, competition)
    @competition = competition
    @failure_full_names = failure_full_names
    @already_subscribed_full_names = already_subscribed_full_names
    @outdated_licence_full_names = outdated_licence_full_names
    @too_young_to_participate_full_names = too_young_to_participate_full_names
    @too_old_to_participate_full_names = too_old_to_participate_full_names
    mail(to: @competition.tournament.user.email, subject: "Bilan de l'export vers AEI de #{@competition.tournament.name} #{@competition.category}")
  end
end
