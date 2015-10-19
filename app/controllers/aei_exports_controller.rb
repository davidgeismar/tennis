class AeiExportsController < ApplicationController
  before_action :set_competition

  def create
    homologation_number_found = false
    @subscription_ids = params[:subscription_ids_export].split(',')
    @tournament = @competition.tournament
    @homologation_number = @tournament.homologation_number.split.join
    authorize @competition
    #different type of errors
    unavailable_for_genre = []
    outdated_licence = []
    already_subscribed_players = []
    strictly_too_young_to_participate = []
    too_young_to_participate = []
    too_old_to_participate = []

    if @subscription_ids.blank?
      redirect_to competition_subscriptions_path(params[:competition_id])
      flash[:alert] = "Vous n'avez sélectionner aucun joueur à exporter"
    else
      #put all instances of selected subcriptions in [@subscriptions_selected]
      @subscriptions_selected = []
      @subscription_ids.each do |subscription_id|
        subscription = Subscription.find(subscription_id.to_i)
        @subscriptions_selected << subscription
      end
      #split @subscription_selected into subscriptions_arrays of maximum 15 instances
      subscriptions_arrays = @subscriptions_selected.each_slice(15).to_a
      #gestion d'erreur
      #stats of successfully and failure exported
      stats = {
        success: [],
        failure: []
      }
      agent = Mechanize.new
      html_body = mechanize_aei_login(agent)
      links = html_body.search('td a.helptip')
      #boucle sur chaque objet nokogiri pour checker le bon numéro d'homologation
      links.each do |soft_link_to_tournament|
        if soft_link_to_tournament.text.split.join == @homologation_number && !homologation_number_found
          homologation_number_found = true
          html_body = following_relevant_tournament(soft_link_to_tournament, agent)
          accessing_players_list_tournament(html_body, agent)
          subscriptions_arrays.each do |subscription_array|
            total_subscriptions = subscription_array.count
            page = agent.get("https://aei.app.fft.fr/ei/joueurRecherche.do?dispatch=afficher&returnMapping=competitionTabJoueurs&entite=COI") # page ou je peux rechercher les joueurs par numéro de licence
            page = searching_for_players(page, agent, subscription_array)
            page = submitting_players(agent, page, total_subscriptions)
            form = agent.page.forms.first
            selecting_players_for_subscription(form, total_subscriptions)
            selecting_category_to_subscribe_player_into(form, outdated_licence, too_young_to_participate, strictly_too_young_to_participate, too_old_to_participate, already_subscribed_players, unavailable_for_genre)
            slice_stats = checking_export(subscription_array, @homologation_number, agent)
            stats[:success] += slice_stats[:success]
            stats[:failure] += slice_stats[:failure]
          end
        end
      end

      unless homologation_number_found
        flash[:alert] = "Le numéro d'homologation n'a pas été trouvé"
        return redirect_to competition_subscriptions_path(@competition)
      end

      success_full_names = stats[:success].map { |subscription| subscription.user.full_name }.join(', ')
      failure_full_names = stats[:failure].map { |subscription| subscription.user.full_name }.join(', ')
      unless already_subscribed_players.blank?
        already_subscribed_full_names = already_subscribed_players.uniq.map {|full_name| full_name}.join(', ')
      else
         already_subscribed_full_names = already_subscribed_players.map {|full_name| full_name}.join(', ')
      end
      unless outdated_licence.blank?
        outdated_licence_full_names = outdated_licence.uniq.map {|full_name| full_name}.join(', ')
      else
        outdated_licence_full_names = outdated_licence.map {|full_name| full_name}.join(', ')
      end
      unless too_young_to_participate.blank?
        too_young_to_participate_full_names = too_young_to_participate.uniq.map {|full_name| full_name}.join(', ')
      else
        too_young_to_participate_full_names = too_young_to_participate.map {|full_name| full_name}.join(', ')
      end
      unless strictly_too_young_to_participate.blank?
        strictly_too_young_to_participate_full_names = strictly_too_young_to_participate.uniq.map {|full_name| full_name}.join(', ')
      else
        strictly_too_young_to_participate_full_names = strictly_too_young_to_participate.map {|full_name| full_name}.join(', ')
      end
      unless too_old_to_participate.blank?
        too_old_to_participate_full_names = too_old_to_participate.uniq.map {|full_name| full_name}.join(', ')
      else
        too_old_to_participate_full_names = too_old_to_participate.map {|full_name| full_name}.join(', ')
      end
      unless unavailable_for_genre.blank?
        unavailable_for_genre_full_names = unavailable_for_genre.uniq.map {|full_name| full_name}.join(', ')
      else
        unavailable_for_genre_full_names = unavailable_for_genre.map {|full_name| full_name}.join(', ')
      end
      total_success = stats[:success].count
      total_failure = stats[:failure].count
      total_already_subscribed = already_subscribed_players.count
      total_outdated_licence = outdated_licence.count
      total_too_young = too_young_to_participate.count
      total_strictly_too_young = strictly_too_young_to_participate.count
      total_too_old = too_old_to_participate.count
      total_unavailable_genre = unavailable_for_genre.count
      flash[:notice]  = "Vous avez exporté #{stats[:success].size} licencié(s) avec succès"

      AeiExportsMailer.export_bilan(failure_full_names, total_failure, success_full_names, total_success, already_subscribed_full_names, total_already_subscribed, outdated_licence_full_names, total_outdated_licence, too_young_to_participate_full_names, total_too_young, strictly_too_young_to_participate_full_names, total_strictly_too_young, too_old_to_participate_full_names, total_too_old, unavailable_for_genre_full_names, total_unavailable_genre, @competition).deliver

      if failure_full_names.present? && outdated_licence_full_names.present?
          flash[:alert]   = "#{outdated_licence_full_names} n'ont pas une licence valide au jour de la compétition. #{failure_full_names} n'ont pas pu être exportés. Merci de vous connecter sur AEI pour procéder à l'inscription manuelle"
      elsif failure_full_names.present? && already_subscribed_players.present? && too_young_to_participate
        flash[:alert]   = "#{already_subscribed_full_names} sont déjà inscrit à ce tournoi dans cette catégorie. #{too_young_to_participate_full_names} sont trop jeunes pour participer au tournoi dans cette catégorie. #{failure_full_names} n'ont pas pu être exportés. Merci de vous connecter sur AEI pour procéder à l'inscription manuelle"
      elsif failure_full_names.present? && too_young_to_participate.present?
        flash[:alert]   = "#{too_young_to_participate_full_names} sont trop jeunes pour participer au tournoi dans cette catégorie. #{failure_full_names} n'ont pas pu être exportés. Merci de vous connecter sur AEI pour procéder à l'inscription manuelle"
      elsif failure_full_names.present?
        flash[:alert]   = "#{failure_full_names} n'ont pas pu être exportés. Merci de vous connecter sur AEI pour procéder à l'inscription manuelle"
      elsif already_subscribed_players.present?
        flash[:alert]   = "#{already_subscribed_full_names} sont déjà inscrit à ce tournoi dans cette catégorie."
      end
      return redirect_to competition_subscriptions_path(@competition)
    end
  end

  def export_disponibilities
    authorize @competition

    if params[:subscription_ids_export_dispo].blank?
      flash[:alert] = "Vous n'avez sélectionner aucun joueur à exporter"
      redirect_to competition_subscriptions_path(competition.id)
    else
      aei = AEI.new(params[:login_aei], params[:password_aei])
      errors = aei.export_disponibilities(@competition, params[:subscription_ids_export_dispo].split(','))

      flash[:notice] = "les disponibilités de vos inscrits ont bien été exportés"
      redirect_to competition_subscriptions_path(@competition)
    end

    rescue AEI::LoginError
      flash[:alert] = "Il n'y a aucun compte avec ces informations."
      redirect_to competition_subscriptions_path(competition)
  end


  private

  def set_competition
    @competition = Competition.find(params[:competition_id])
    custom_authorize AEIExportPolicy, @competition
  end

end
