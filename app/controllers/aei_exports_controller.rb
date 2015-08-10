class AeiExportsController < ApplicationController
  before_action :set_tournament

  def create
    @subscription_ids = params[:subscription_ids_export].split(',')
    @tournament = Tournament.find(params[:tournament_id])
    authorize @tournament

    if @subscription_ids.blank?
      redirect_to tournament_subscriptions_path(params[:tournament_id])
      flash[:alert] = "Vous n'avez sélectionner aucun joueur à exporter"
    else
      #put all selected subcriptions in [@subscriptions_selected]
      @subscriptions_selected = []
      @subscription_ids.each do |subscription_id|
        subscription = Subscription.find(subscription_id.to_i)
        @subscriptions_selected << subscription

      end

      #split array d'instance d'inscriptions into arrays de max 15 instances
      subscriptions_arrays = @subscriptions_selected.each_slice(15).to_a
      stats = {
        success: [],
        failure: []
      }

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

        # checking right homologation number for tournament
        # si ça existe (Compétitions)
        if html_body.search('td a.treeview2').first.present?
          links = html_body.search('a.helptip')

            homologation_number_found = false

            links.each do |a|
            # try with 2015 32 92 0076 not working why ?

              # if a.text.split.join ==  @tournament.homologation_number.split.join && !homologation_number_found
              if a.text.split.join == "201532920419" && !homologation_number_found
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
                  # puts html_body

                  form = agent.page.forms.first

                  numbers = (0...total_subscriptions)

                  # checking all checkboxes for players
                  numbers.each do |number|
                    checkbox = form.checkbox_with(:name => 'pp_ino_selection['+ number.to_s + ']')

                    if checkbox.present?
                      checkbox.check
                    end
                  end

                  # selecting the right category to subscribe the player into
                  form.checkboxes.each do |checkbox|
                    td = checkbox.node.parent
                    tr = td.parent

                    # category_nature can be SM or SD
                    category_nature      = tr.search('td')[2].text
                    # category_age is the actual category
                    category_age         = tr.search('td')[3].text
                    tournament_category = "#{@tournament.genre}_#{@tournament.category}"
                    aei_category_nature = I18n.t("aei.tournament_nature.#{category_nature}")
                    aei_category_age    = I18n.t("aei.tournament_age_category.#{category_age}")

                    raise
                    # aei_tournament_cat  =
                    # I18n.t("aei.tournament_category.#{tournament_category}")
                    if aei_tournament_cat == category_title

                      checkbox.check

                      # submitting inscription
                      form.field_with(:name => 'dispatch').value = "inscrire"
                      page = form.submit
                      body = page.body
                      html_body = Nokogiri::HTML(body)
                      puts html_body
                      puts html_body.search('li').text
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


      flash[:notice]  = "Vous avez exporté #{stats[:success].size} avec succès"

      if failure_full_names.present?

        flash[:alert]   = "#{failure_full_names} n'ont pas pu être exportés. Merci de vous connecter sur AEI pour procéder à l'inscription manuelle"
      end

      redirect_to tournament_subscriptions_path(@tournament)
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

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
    custom_authorize AEIExportPolicy, @tournament
  end
end
