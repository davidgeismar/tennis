class AeiExportsMailer < ApplicationMailer
  default from: 'contact@wetennis.fr'

  def export_bilan(failure_full_names, total_failure, success_full_names, total_success, already_subscribed_full_names, total_already_subscribed, outdated_licence_full_names, total_outdated_licence, too_young_to_participate_full_names, total_too_young, strictly_too_young_to_participate_full_names, total_strictly_too_young, too_old_to_participate_full_names, total_too_old, unavailable_for_genre_full_names, total_unvailable_genre, competition)
    @competition = competition
    @success_full_names = success_full_names
    @total_success = total_success
    @failure_full_names = failure_full_names
    @total_failure = total_failure
    @already_subscribed_full_names = already_subscribed_full_names
    @total_already_subscribed = total_already_subscribed
    @outdated_licence_full_names = outdated_licence_full_names
    @total_outdated_licence = total_outdated_licence
    @too_young_to_participate_full_names = too_young_to_participate_full_names
    @total_too_young = total_too_young
    @strictly_too_young_to_participate_full_names = strictly_too_young_to_participate_full_names
    @total_strictly_too_young = total_strictly_too_young
    @too_old_to_participate_full_names = too_old_to_participate_full_names
    @total_too_old = total_too_old
    @unavailable_for_genre_full_names  = unavailable_for_genre_full_names
    @total_unvailable_genre = total_unvailable_genre
    mail(to: @competition.tournament.user.email, subject: "Bilan de l'export vers AEI de #{@competition.tournament.name} #{@competition.category}")
  end
end
