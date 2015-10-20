# AEI

class AEI

  class LoginError < RuntimeError; end;

  attr_accessor :login_aei, :password_aei

  def initialize(login_aei, password_aei)
    @login_aei = login_aei
    @password_aei = password_aei
  end

  def export_disponibilities(competition, subscription_ids)
    # je récupère les joueurs sélectionnés
    no_disponibility = []
    failure = []
    success = []
    competition_category = "#{competition.genre}_#{competition.category}"
    aei_competition_category_shortcut  = I18n.t("aei.competition_category_shortcut.#{competition_category}")
    homologation_number_found = false

        Rails.logger.debug "@@@ #{__LINE__}"
    subscriptions_valids = []
    users_not_yet_exported = []
    subscription_ids.each do |subscription_id|
      #instance of subscriptions selected are added in array
      subscription = Subscription.find(subscription_id.to_i)
      # pour que l'on puisse exporter les dispos il faut que le joueur ai été exporté préalablement
      if subscription.exported?
        subscriptions_valids << subscription
      else
        # joueur qui n'ont pas encore été exporté sont stockés ici
        users_not_yet_exported << subscription.user.full_name
      end
    end

        Rails.logger.debug "@@@ #{__LINE__}"
    agent = Mechanize.new
    html_body = mechanize_aei_login(agent)
    links = html_body.search('td a.helptip')
    links.each do |soft_link_to_tournament|
      #checking if homologation number matches homologation number on AEI
      if soft_link_to_tournament.text.split.join == competition.tournament.homologation_number.split.join && !homologation_number_found
        homologation_number_found = true
        hard_link_to_tournament = soft_link_to_tournament.parent.previous_element.at('a')[:href]
        Rails.logger.debug "@@@ #{__LINE__}"
        html_body = following_relevant_tournament(soft_link_to_tournament, agent)
        epreuves_access = html_body.search('#tabs0head1 a').first
        lien_epreuves = epreuves_access[:href]
        page_epreuves = agent.get(lien_epreuves)
        html_body = Nokogiri::HTML(page_epreuves.body)
        Rails.logger.debug "@@@ #{__LINE__}"
        html_body.search('tr td[3]').each do |nat_cat|
          if nat_cat.text.split.join == aei_competition_category_shortcut.split.join
            lien_epreuve = nat_cat.previous_element.previous_element.at('a')[:href]
            page_epreuve = agent.get(lien_epreuve) # suit le lien vers la bonne épreuve
            html_body = Nokogiri::HTML(page_epreuve.body)
            subscriptions_access = html_body.search('#tabs0head1 a').first
            lien_joueurs_inscrits = subscriptions_access[:href]
        Rails.logger.debug "@@@ #{__LINE__}"
            page_joueurs_inscrits = agent.get(lien_joueurs_inscrits)
            html_body = Nokogiri::HTML(page_joueurs_inscrits.body)

            # works on first page
            valids = html_body.search('table.L1 table td[3] a')
            array_subscribed_players_cat = valids.map { |valid| {valid.text.downcase.split.join => valid[:href]} }
            link_number = 2

        Rails.logger.debug "@@@ #{__LINE__}"
            # running through pagination
            while lien = page_joueurs_inscrits.link_with(:text=> link_number.to_s)
               page_joueurs_inscrits = lien.click
               body = page_joueurs_inscrits.body
               html_body = Nokogiri::HTML(body)
               valids = html_body.search('table.L1 table td[3] a')
               array_subscribed_players_cat += valids.map { |valid| {valid.text.downcase.split.join => valid[:href]} }

               link_number = link_number + 1
            end

        Rails.logger.debug "@@@ #{__LINE__}"
            results = {}
            subscriptions_valids.each do |subscription|
                if array_subscribed_players_cat.each do |player|
                    if (player.keys.first.split.join.downcase == subscription.user.full_name.split.join.downcase) || (player.keys.first.split.join.downcase == subscription.user.full_name_inversed.split.join.downcase)
                        results[subscription] = player[player.keys.first]
                    end
                  end
                end
            end


        Rails.logger.debug "@@@ #{__LINE__}"
            results.each do |subscription, player_path|

              jou_iid = player_path[/jou_iid=(\d+)&/, 1]

              player_page_uri = "https://aei.app.fft.fr/ei/#{player_path}"
              player_page = agent.get player_page_uri

              body = player_page.body
              html_body = Nokogiri::HTML(body)
              input = html_body.css('center').last.css('input')

              disponibility = Disponibility.where(tournament: competition.tournament, user: subscription.user).first
              player_all_dispo = "L#{disponibility.monday} M#{disponibility.tuesday} Me#{disponibility.wednesday} J #{disponibility.thursday} V#{disponibility.friday} S#{disponibility.saturday} D#{disponibility.sunday}"

              player_edition_page_uri = "https://aei.app.fft.fr/ei/joueurFiche.do?dispatch=afficher&jou_iid=#{jou_iid}&returnMapping=joueurTabInfo"
              player_edition_page = agent.get player_edition_page_uri

        Rails.logger.debug "@@@ #{__LINE__}"
              user_form = player_edition_page.forms.first
              user_form.jou_vcomment = player_all_dispo
              page = user_form.submit

            end

=begin


            # headless = Headless.new
            # headless.start
            browser = Watir::Browser.new :phantomjs
            browser.goto "https://aei.app.fft.fr/ei/connexion.do?dispatch=afficher"
            browser.text_field(name: "util_vlogin").set @login_aei
            browser.text_field(name: "util_vpassword").set @password_aei
            browser.button(value: "Connexion").click
            results.each do |result|
              result.each do |subscription, link|
                if disponibility = Disponibility.where(tournament: competition.tournament, user: subscription.user).first
                  all_dispo = "L#{disponibility.monday} M#{disponibility.tuesday} Me#{disponibility.wednesday} J #{disponibility.thursday} V#{disponibility.friday} S#{disponibility.saturday} D#{disponibility.sunday}"
                  link = link.gsub("epreuve", "competition").gsub("Inscriptions", "Joueurs")
                  browser.goto "https://aei.app.fft.fr/ei/" + hard_link_to_tournament
                  browser.goto "https://aei.app.fft.fr/ei/" + link
                  browser.button(value: "Modifier").click
                  browser.text_field(name: "jou_vcomment").set all_dispo
                  browser.button(value: "Valider").click
                else
                 no_disponibility << subscription
                end
              end
            end
            # browser.close
            # headless.destroy
=end

          end
        end
      end
    end
  end

  def mechanize_aei_login(agent)
    agent.get("https://aei.app.fft.fr/ei/connexion.do?dispatch=afficher")
    form_login_AEI = agent.page.forms.first
    form_login_AEI.util_vlogin = @login_aei
    form_login_AEI.util_vpassword = @password_aei
    page_compet_list = agent.submit(form_login_AEI, form_login_AEI.buttons.first)
    html_body = Nokogiri::HTML(page_compet_list.body)

    #gestion d'erreur à la connexion
    login_result = html_body.search("td li").text

    if login_result == "Il n'y a aucun compte avec ces informations." || login_result == "Le mot de passe indiqué n'est pas correct."
      raise LoginError
    else
      html_body
    end
  end

  def following_relevant_tournament(soft_link_to_tournament, agent)
    hard_link_to_tournament = soft_link_to_tournament.parent.previous_element.at('a')[:href] # selecting the link to follow which is in the previous td
    page_profil_tournament = agent.get(hard_link_to_tournament) #following the link to tournament profile
    return html_body = Nokogiri::HTML(page_profil_tournament.body)
  end

  def accessing_players_list_tournament(html_body, agent)
    joueur_access = html_body.search('#tabs0head2 a').first #finding tab "Joueurs"
    lien_joueurs_inscrits = joueur_access[:href] # link to player_tab
    return page_joueurs_inscrits = agent.get(lien_joueurs_inscrits) #following link on the player_tabs
  end


  def searching_for_players(page, agent, subscription_array)
    html_body = Nokogiri::HTML(page.body)
    form = agent.page.forms.first
    total_subscriptions = subscription_array.count
    # filling out form with with licence numbers
    subscription_array.each_with_index do |subscription, index|
      form.field_with(:name => 'lic_cno['+ index.to_s + ']').value = subscription.user.licence_number_custom
    end
    # submitting form for research of players
    form.field_with(:name => 'dispatch').value = "rechercher"
    # select players page
    return form.submit
  end

  def submitting_players(agent, page, total_subscriptions)
    form = agent.page.forms.first
    # selecting all checkboxes in the form
    numbers = (0...total_subscriptions)
    numbers.each do |number|
      checkbox = form.checkbox_with(:name => 'lic_cno_selection[' + number.to_s + ']')
      if checkbox.present?
        checkbox.check
      end
    end
    # selecting each players found throught the form
    form.field_with(:name => 'dispatch').value = "selectionner"
    # inscription page
    return form.submit
  end

  def selecting_players_for_subscription(form, total_subscriptions)
    numbers = (0...total_subscriptions)
    # checking all checkboxes for players = selecting all players before selecting category in which subscribing them
    numbers.each do |number|
      checkbox = form.checkbox_with(:name => 'pp_ino_selection['+ number.to_s + ']')
      if checkbox.present?
        checkbox.check
      end
    end
  end

  def selecting_category_to_subscribe_player_into(competition, form, outdated_licence, too_young_to_participate, strictly_too_young_to_participate, too_old_to_participate, already_subscribed_players, unavailable_for_genre)
    # selecting the right category to subscribe the player into
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
      competition_category = "#{competition.genre}_#{competition.category}"
      # i18n terminology for each
      aei_competition_category  = I18n.t("aei.competition_category.#{competition_category}")
      aei_category_nature = I18n.t("aei.competition_nature.#{category_nature}")
      aei_category_age    = I18n.t("aei.competition_age_category.#{category_age}")

      # double checking possibility
      if aei_competition_category == category_title
        checkbox.check
        # submitting inscription
        form.field_with(:name => 'dispatch').value = "inscrire"
        page = form.submit
        html_body = Nokogiri::HTML(page.body)
        error_checking(html_body, outdated_licence, too_young_to_participate, strictly_too_young_to_participate, too_old_to_participate, already_subscribed_players, unavailable_for_genre)
      elsif category_nature.present? && category_age.present? && ("#{aei_category_nature} #{aei_category_age}" == aei_competition_category)
        checkbox.check
        # submitting inscription
        form.field_with(:name => 'dispatch').value = "inscrire"
        page = form.submit
        html_body = Nokogiri::HTML(page.body)
        error_checking(html_body, outdated_licence, too_young_to_participate, strictly_too_young_to_participate, too_old_to_participate, already_subscribed_players, unavailable_for_genre)
      end
    end
  end

   def checking_export(competition, subscription_array, homologation_number, agent)
    competition_category = "#{competition.genre}_#{competition.category}"
    aei_competition_category_shortcut  = I18n.t("aei.competition_category_shortcut.#{competition_category}")
    html_body = mechanize_aei_login(agent)
    homologation_number_found = false
    links = html_body.search('td a.helptip')
    links.each do |soft_link_to_tournament|
      if soft_link_to_tournament.text.split.join == homologation_number
        homologation_number_found = true
        hard_link_to_tournament = soft_link_to_tournament.parent.previous_element.at('a')[:href] # selecting the link to follow which is in the previous td
        page_profil_tournament = agent.get(hard_link_to_tournament) #following the link to tournament profile
        html_body = Nokogiri::HTML(page_profil_tournament.body)
        epreuves_access = html_body.search('#tabs0head1 a').first
        lien_epreuves = epreuves_access[:href]
        page_epreuves = agent.get(lien_epreuves)
        html_body = Nokogiri::HTML(page_epreuves.body)
        html_body.search('tr td[3]').each do |nat_cat|
          if nat_cat.text.split.join == aei_competition_category_shortcut.split.join

            lien_epreuve = nat_cat.previous_element.previous_element.at('a')[:href]
            page_epreuve = agent.get(lien_epreuve) # suit le lien vers la bonne épreuve
            html_body = Nokogiri::HTML(page_epreuve.body)
            subscriptions_access = html_body.search('#tabs0head1 a').first
            lien_joueurs_inscrits = subscriptions_access[:href]
            page_joueurs_inscrits = agent.get(lien_joueurs_inscrits)
            html_body = Nokogiri::HTML(page_joueurs_inscrits.body)
            valids = html_body.search('table.L1 table td[3]')
            array_subscribed_players = valids.map { |valid| valid.text.downcase.strip }
        # clique sur le lien page 2, 3, 4...
            link_number = 2
            while lien = page_joueurs_inscrits.link_with(:text=> link_number.to_s)

              page_joueurs_inscrits = lien.click
              body = page_joueurs_inscrits.body
              html_body = Nokogiri::HTML(body)
              valids = html_body.search('table.L1 table td[3]')
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
    end
  end

  private

  def error_checking(html_body, outdated_licence, too_young_to_participate, too_old_to_participate, already_subscribed_players, unavailable_for_genre, strictly_too_young_to_participate)
    # dans search ajouter .L1
    html_body.search('td td .L1').each do |error_mess|
      puts (error_mess.text.strip + " I'm an error mess ")
      if error_mess.text.strip == "Raison de l'alerte"
      elsif error_mess.text.include?("trop jeune pour participer à l'épreuve") && error_mess.text.include?("Raison de l'alerte")
        name = error_mess.text.slice(0...(error_mess.text.index(" : trop jeune pour participer à l'épreuve")))
        name =  name.gsub("Raison de l'alerte", "").gsub(/\r/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").gsub(/\A\p{Space}*|\p{Space}*\z/, '').strip
        too_young_to_participate << name
      elsif error_mess.text.include?("trop jeune pour participer à l'épreuve")
        name = error_mess.text.slice(0...(error_mess.text.index(" : trop jeune pour participer à l'épreuve"))).gsub(/\r/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").gsub(/\A\p{Space}*|\p{Space}*\z/, '').strip
        too_young_to_participate << name
      end
    end

    html_body.search('td td .L2').each do |error_mess|
      puts (error_mess.text.strip + " I'm an error mess ")
      if error_mess.text.strip == "Raison de l'alerte"
      elsif error_mess.text.include?("trop jeune pour participer à l'épreuve") && error_mess.text.include?("Raison de l'alerte")
        name = error_mess.text.slice(0...(error_mess.text.index(" : trop jeune pour participer à l'épreuve")))
        name =  name.gsub("Raison de l'alerte", "").gsub(/\r/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").gsub(/\A\p{Space}*|\p{Space}*\z/, '').strip
        too_young_to_participate << name
      elsif error_mess.text.include?("trop jeune pour participer à l'épreuve")
        name = error_mess.text.slice(0...(error_mess.text.index(" : trop jeune pour participer à l'épreuve"))).gsub(/\r/,"").gsub(/\r/,"").gsub(/\n/,"").gsub(/\t/,"").gsub(/\A\p{Space}*|\p{Space}*\z/, '').strip
        too_young_to_participate << name
      end
    end

    html_body.search('li').each do |error_mess|
      if error_mess.text.include?("trop jeune pour participer à l'épreuve")
        name = error_mess.text.slice(0...(error_mess.text.index(" : trop jeune pour participer à l'épreuve")))
        strictly_too_young_to_participate << name
      elsif error_mess.text.include?("est trop âgé pour participer")
        name = error_mess.text.slice(0...(error_mess.text.index(" est trop âgé pour participer")))
        too_old_to_participate << name
      elsif error_mess.text.include?('est déjà inscrit(e)')
        name = error_mess.text.slice(0...(error_mess.text.index('est déjà inscrit(e)')))
        already_subscribed_players << name
      elsif error_mess.text.include?('Passé le')
        name = error_mess.text.slice(0...(error_mess.text.index(' : Passé le')))
        outdated_licence << name
      elsif error_mess.text.include?('Veuillez vérifier le sexe')
        name = error_mess.text.slice(0...(error_mess.text.index(" n'a pu être inscrit. Veuillez vérifier le sexe")))
        unavailable_for_genre << name
      end
    end
    return too_young_to_participate, strictly_too_young_to_participate, too_old_to_participate, already_subscribed_players, outdated_licence, unavailable_for_genre
  end

  def watir_aei_login
    browser = Watir::Browser.new
    browser.goto "https://aei.app.fft.fr/ei/connexion.do?dispatch=afficher"
    browser.text_field(name: "util_vlogin").set @login_aei
    browser.text_field(name: "util_vpassword").set @password_aei
    browser.button(value: "Connexion").click
  end

end
