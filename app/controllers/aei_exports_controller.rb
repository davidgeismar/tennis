class AeiExportsController < ApplicationController
  before_action :set_competition

  def create
    @subscription_ids = params[:subscription_ids_export].split(',')
    @tournament = @competition.tournament
    authorize @competition
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
      #different type of errors
      outdated_licence = []
      already_subscribed_players = []
      too_young_to_participate = []
      subscriptions_arrays.each do |subscription_array|
        agent = Mechanize.new
        agent.get("https://aei.app.fft.fr/ei/connexion.do?dispatch=afficher")
        # login into AEI
        # gestion d'erreur si mot de passe fourni ou login fourni mauvais redirect avec
        # if errors = html_body.search(erreur)
        #  flash[:alert] = "Vos identifiants n'ont n'a pas été reconnu"
        form_login_AEI = agent.page.forms.first
        form_login_AEI.util_vlogin = params[:login_aei]
        form_login_AEI.util_vpassword = params[:password_aei]
        page_compet_list = agent.submit(form_login_AEI, form_login_AEI.buttons.first)
        body = page_compet_list.body
        html_body = Nokogiri::HTML(body)

        if html_body.search("td li").text == "Il n'y a aucun compte avec ces informations."
          flash[:alert] = "Il n'y a aucun compte avec ces informations."
          redirect_to competition_subscriptions_path(@competition) and return
        else
        end
        # checking right homologation number for tournament
        # si ça existe (Compétitions)
        if html_body.search('td a.treeview2').first.present?
          links = html_body.search('a.helptip')

            homologation_number_found = false

            links.each do |a|
            # try with 2015 32 92 0076 not working why ?

            # pour l'export en test il faut continuer avec le numéro de test 2015 32 92 0419
              if a.text.split.join == @tournament.homologation_number.split.join && !homologation_number_found

                homologation_number_found = true


                a = a.parent.previous.previous
                a = a.at('a')[:href] # selecting the link to follow
                page_selected_compet = agent.get(a) #following the link
                body = page_selected_compet.body
                html_body = Nokogiri::HTML(body)
                joueur_access = html_body.search('#tabs0head2 a').each do |a| #wtf here
                  lien_joueurs_inscrits = a[:href] #following link on the player_tabs
                  page = agent.get("https://aei.app.fft.fr/ei/joueurRecherche.do?dispatch=afficher&returnMapping=competitionTabJoueurs&entite=COI") #getting the link in Par numéro de licence
                  body = page.body
                  html_body = Nokogiri::HTML(body)
                  form = agent.page.forms.first
                  number = 0
                  total_subscriptions = subscription_array.count
                  # filling out form with with licence numbers
                  subscription_array.each_with_index do |subscription, index|
                    form.field_with(:name => 'lic_cno['+ index.to_s + ']').value = subscription.user.licence_number_custom
                  end

                  # submitting form for research of players
                  form.field_with(:name => 'dispatch').value = "rechercher"
                  # select players page
                  page = form.submit
                  body = page.body
                  html_body = Nokogiri::HTML(body)
                  form = agent.page.forms.first
                  # form.checkbox_with(:name => 'sel').value = true
                  # selecting all checkboxes in the form
                  number = 0
                  numbers = (number...total_subscriptions)
                  numbers.each do |number|
                    checkbox = form.checkbox_with(:name => 'lic_cno_selection[' + number.to_s + ']')

                    if checkbox.present?
                      checkbox.check
                    end
                  end

                  # selecting each players found throught the form
                  #https://aei.app.fft.fr/ei/joueurRecherche.do
                  form.field_with(:name => 'dispatch').value = "selectionner"
                  # inscription page
                  page = form.submit
                  body = page.body
                  html_body = Nokogiri::HTML(body)
                  puts html_body

                  form = agent.page.forms.first

                  numbers = (0...total_subscriptions)

                  # checking all checkboxes for players = selecting all players before selecting category in which subscribing them
                  numbers.each do |number|
                    checkbox = form.checkbox_with(:name => 'pp_ino_selection['+ number.to_s + ']')

                    if checkbox.present?
                      checkbox.check
                    end
                  end

                  # selecting the right category to subscribe the player into
                  # we are actually selecting all checkboxes from the page so we also have the checkbox that are related to the players
                  # checkbox for players have name pp_ino_selection whereas checkbox for category have epr_iid_selection name
                  form.checkboxes.each do |checkbox|
                    td = checkbox.node.parent
                    tr = td.parent
                    # crosschecking category_title with category_nature and category_age
                    # category_title is given by the JA
                    category_title      = tr.search('td')[1].text
                    # category_nature can be SM or SD
                    category_nature      = tr.search('td')[2].text.strip
                    # category_age is the actual category
                    category_age         = tr.search('td')[3].text
                    competition_category = "#{@competition.genre}_#{@competition.category}"

                    # i18n terminology for each
                    aei_competition_category  = I18n.t("aei.competition_category.#{competition_category}")
                    aei_category_nature = I18n.t("aei.competition_nature.#{category_nature}")
                    aei_category_age    = I18n.t("aei.competition_age_category.#{category_age}")


                    # aei_tournament_cat  =
                    # I18n.t("aei.tournament_category.#{tournament_category}")

                    if aei_competition_category == category_title


                      checkbox.check

                      # submitting inscription
                      form.field_with(:name => 'dispatch').value = "inscrire"
                      page = form.submit
                      body = page.body
                      html_body = Nokogiri::HTML(body)
                      puts html_body
                      puts html_body.search('li').text


                    elsif category_nature.present? && category_age.present? && ("#{aei_category_nature} #{aei_category_age}" == aei_competition_category)

                       checkbox.check


                      #enters but doesnt work
                      # submitting inscription

                      form.field_with(:name => 'dispatch').value = "inscrire"
                      page = form.submit
                      body = page.body
                      html_body = Nokogiri::HTML(body)


                      # puts html_body

                      #players who are too young to participate
                      html_body.search('.L1').each do |mess|
                        puts mess
                        if mess.text.include?("trop jeune pour participer à l'épreuve")
                          name = mess.text.slice(0...(mess.text.index(" : trop jeune pour participer à l'épreuve")))
                          too_young_to_participate << name
                        else
                        end
                      end
                      # gestion joueur déjà inscrit
                      # str = html_body.search('li').text
                      html_body.search('li').each do |li|
                        #already_subscribed

                       if li.text.include?('est déjà inscrit(e)')
                          name = li.text.slice(0...(li.text.index('est déjà inscrit(e)')))
                          puts name
                          already_subscribed_players << name
                        #licence non valide
                        elsif li.text.include?('Passé le')
                          name = li.text.slice(0...(li.text.index(' : Passé le')))
                          puts name
                          outdated_licence << name
                        else
                          puts licence
                        end
                      end
                    end
                  end

                  slice_stats = checking_export(subscription_array)
                  stats[:success] += slice_stats[:success]
                  stats[:failure] += slice_stats[:failure]
                  # number_validated_subscriptions == array_validated_subscriptions.count
                end

                # redirect_to tournament_subscriptions_path(@tournament)
              end
            end

            unless homologation_number_found

              flash[:danger] = "Le numéro d'homologation n'a pas été reconnu" #va me le faire a chaque fois
              # redirect_to tournament_subscriptions_path(@tournament)
              # return
            end
        else
          flash[:alert] = "Votre identifiant ou votre mot de passe AEI ne sont pas valables"
        end
      end

      failure_full_names = stats[:failure].map { |subscription| subscription.user.full_name }.join(', ')
      already_subscribed_full_names = already_subscribed_players.map {|full_name| full_name}.join(', ')
      outdated_licence_full_names = outdated_licence.map {|full_name| full_name}.join(', ')
      too_young_to_participate_full_names = too_young_to_participate.map {|full_name| full_name}.join(', ')

      flash[:notice]  = "Vous avez exporté #{stats[:success].size} licencié(s) avec succès"

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

      redirect_to competition_subscriptions_path(@competition)
    end
  end

  def export_disponibilities
    # je récupère les joueurs sélectionnés
    @subscription_ids = params[:subscription_ids_export_dispo].split(',')
    @tournament = @competition.tournament
    authorize @competition
    if @subscription_ids.blank?
      flash[:alert] = "Vous n'avez sélectionner aucun joueur à exporter"
      redirect_to competition_subscriptions_path(params[:competition_id])
    else
       #put all selected subcriptions in [@subscriptions_selected]
      @subscriptions_selected = []
      @users_not_yet_exported = []
      @subscription_ids.each do |subscription_id|
        #instance of subscriptions selected are added in array
        subscription = Subscription.find(subscription_id.to_i)
        # pour que l'on puisse exporter les dispos il faut que le joueur ai été exporté préalablement
        if subscription.exported?
          @subscriptions_selected << subscription
        else
          # joueur qui n'ont pas encore été exporté sont stockés ici
          @users_not_yet_exported << subscription.user.full_name
        end
      end
      agent = Mechanize.new
      agent.get("https://aei.app.fft.fr/ei/connexion.do?dispatch=afficher")
      # login into AEI
      # gestion d'erreur si mot de passe fourni ou login fourni mauvais redirect avec
      # if errors = html_body.search(erreur)
      #  flash[:alert] = "Vos identifiants n'ont n'a pas été reconnu"
      form_login_AEI = agent.page.forms.first
      form_login_AEI.util_vlogin = params[:login_aei]
      form_login_AEI.util_vpassword = params[:password_aei]
      page_compet_list = agent.submit(form_login_AEI, form_login_AEI.buttons.first)
      # page avec la liste des tournois dont s'occupe le JA classés pas numéro de licence
      body = page_compet_list.body
      html_body = Nokogiri::HTML(body)
      if html_body.search('td a.treeview2').first.present?
        links = html_body.search('a.helptip')
        homologation_number_found = false
        links.each do |a|
          #checking if homologation number matches homologation number on AEI
          if a.text.split.join == @tournament.homologation_number.split.join && !homologation_number_found
            homologation_number_found = true
            a = a.parent.previous.previous
            a_tournament = a.at('a')[:href] # selecting the link to profile_tournament
            page_selected_compet = agent.get(a_tournament) #following the link to profile_tournement
            body = page_selected_compet.body
            html_body = Nokogiri::HTML(body)
            joueur_access = html_body.search('#tabs0head2 a') #finding tab "Joueurs"
            joueur_access.each do |a| #wtf here
               lien_joueurs_inscrits = a[:href] # link to player_tab
               page_joueurs_inscrits = agent.get(lien_joueurs_inscrits) #following link on the player_tabs
               body = page_joueurs_inscrits.body
               html_body = Nokogiri::HTML(body)
               browser = Watir::Browser.new
               browser.goto "https://aei.app.fft.fr/ei/connexion.do?dispatch=afficher"
               browser.text_field(name: "util_vlogin").set params[:login_aei]
               browser.text_field(name: "util_vpassword").set params[:password_aei]
               browser.button(value: "Connexion").click
               failures = []
               success = []
               @subscriptions_selected.each do |subscription|
                  link_number = 2
                  while lien = page_joueurs_inscrits.link_with(:text=> link_number.to_s)
                    names = html_body.search('.L2') + html_body.search('.L1')
                    names.each do |name|
                      # if player's name is found in player's list (il faut que le robot puisse passer de page en page !)
                      if (subscription.user.full_name.split.join.downcase == name.text.split.join.downcase) || (subscription.user.full_name_inversed.split.join.downcase == name.text.split.join.downcase)
                        a = name.previous.previous
                        a = a.at('a')[:href] # selecting the link to profile_player
                        user_disponibility = Disponibility.where(user: subscription.user, tournament_id: subscription.tournament.id)
                        user_disponibilities = "hello"

                        # browser is callded to go post on each field

                        browser.goto "https://aei.app.fft.fr/ei/" + a_tournament
                        browser.goto "https://aei.app.fft.fr/ei/" + a
                        browser.button(value: "Modifier").click
                        browser.text_field(name: "jou_vcomment").set user_disponibilities
                        browser.button(value: "Valider").click


                      else
                        page_joueurs_inscrits = lien.click
                        body = page_joueurs_inscrits.body
                        html_body = Nokogiri::HTML(body)
                        link_number = link_number + 1

                      end
                    end
                  end
                end
            end
          end
        end
      end
    flash[:notice] = "les disponibilités de vos inscrits ont bien été exportés"
    redirect_to root_path
    end
  end


  private

  def checking_export(subscription_array)
    agent = Mechanize.new
    agent.get("https://aei.app.fft.fr/ei/connexion.do?dispatch=afficher")
    # login into AEI
    # gestion d'erreur si mot de passe fourni ou login fourni mauvais redirect avec
    # if errors = html_body.search(erreur)
    #  flash[:alert] = "Vos identifiants n'ont n'a pas été reconnu"
    form_login_AEI = agent.page.forms.first
    form_login_AEI.util_vlogin = params[:login_aei]
    form_login_AEI.util_vpassword = params[:password_aei]
    page_compet_list = agent.submit(form_login_AEI, form_login_AEI.buttons.first)
    body = page_compet_list.body

    page_compet_list = agent.get("https://aei.app.fft.fr/ei/competitions.do?dispatch=afficher")
    body = page_compet_list.body
    html_body = Nokogiri::HTML(body)
    links = html_body.search('a.helptip')
    homologation_number_found = false

    links.each do |a|
    # try with 2015 32 92 0076 not working why ?
    # if a.text.split.join ==  @tournament.homologation_number.split.join
      if a.text.split.join == "201532920419"
        homologation_number_found = true
        a = a.parent.previous.previous
        a = a.at('a')[:href] # selecting the link to follow
        page_selected_compet = agent.get(a) #following the link
        body = page_selected_compet.body
        html_body = Nokogiri::HTML(body)

        joueur_access = html_body.search('#tabs0head2 a').first
        lien_joueurs_inscrits = joueur_access[:href]
        page_joueurs_inscrits = agent.get(lien_joueurs_inscrits)


        body = page_joueurs_inscrits.body
        html_body = Nokogiri::HTML(body)
        valids = html_body.search('table.L1 table td[2]')
        array_subscribed_players = valids.map { |valid| valid.text.downcase.strip }



        # clique sur le lien page 2, 3, 4...
        link_number = 2
        while lien = page_joueurs_inscrits.link_with(:text=> link_number.to_s)

          page_joueurs_inscrits = lien.click
          body = page_joueurs_inscrits.body
          html_body = Nokogiri::HTML(body)
          valids = html_body.search('table.L1 table td[2]')
          array_subscribed_players += valids.map { |valid| valid.text.downcase.strip }
          link_number = link_number + 1

        end

         stats = {
            success: [],
            failure: []
          }
        subscription_array.each do |subscription|
          if array_subscribed_players.include?(subscription.user.full_name_inversed.downcase.strip) || array_subscribed_players.include?(subscription.user.full_name.downcase.strip)
            stats[:success] << subscription

          else
            stats[:failure] << subscription

          end
        end
        stats[:success].each do |subscription|
          subscription.exported = true
          subscription.save
        end
        return stats

      end
    end
  end

  def set_competition
    @competition = Competition.find(params[:competition_id])
    custom_authorize AEIExportPolicy, @competition
  end
end
