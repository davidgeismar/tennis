class AEIExportsController < ApplicationController
  before_filter :set_tournament

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
          if html_body.search('td a.treeview2').first != []
            links = html_body.search('a.helptip')


              links.each do |a|
              # try with 2015 32 92 0076 not working why ?
              raise
                if a.text.split.join ==  @tournament.homologation_number.split.join

                    a = a.parent.previous.previous
                    a = a.at('a')[:href] # selecting the link to follow
                    page_selected_compet = agent.get(a) #following the link
                    body = page_selected_compet.body
                    html_body = Nokogiri::HTML(body)
                    joueur_access = html_body.search('#tabs0head2 a').each do |a|
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
                        if form.checkbox_with(:name => 'lic_cno_selection[' + number.to_s + ']').blank?
                        else
                          form.checkbox_with(:name => 'lic_cno_selection[' + number.to_s + ']').check
                        end
                      end

                      # selecting each players found throught the form
                      form.field_with(:name => 'dispatch').value = "selectionner"
                      # inscription page
                      page = form.submit
                      body = page.body
                      html_body = Nokogiri::HTML(body)
                      form = agent.page.forms.first
                      number = 0
                      numbers = (number...total_subscriptions)
                      # checking all checkboxes for players
                      numbers.each do |number|
                        if form.checkbox_with(:name => 'pp_ino_selection['+ number.to_s + ']').blank?
                        else
                          form.checkbox_with(:name => 'pp_ino_selection['+ number.to_s + ']').check
                        end
                      end
                       # need to code which category I have to select by checking the TM tournament category
                       #if @tournament.category = "senior"
                       #check xpath with text senior
                       # .parent.form.checkbox...
                       categories = html_body.search('.L1 table td[2]')
                        categories.each do |category|
                            if category.text == "Simple Messieurs Senior"
                              category.parent.children.children[1]
                              form.field_with(:name => 'dispatch').value = "inscrire"
                              form.submit
                              raise
                            end
                        end


                       if @tournament.category == 'seniors' && @tournament.genre == 'male'
                          categories.each do |category|
                            if category.text == "Simple Messieurs Senior"
                              form.checkbox_with(:name => 'epr_iid_selection[1]').check
                              #submitting inscription
                              form.field_with(:name => 'dispatch').value = "inscrire"
                              form.submit
                            else
                            end
                          end
                       elsif @tournament.category == '45 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 45"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                       elsif @tournament.category == '35 ans' && @tournament.genre == 'male'
                            categories.each do |category|
                                if category.text == "Simple Messieurs 35"
                                  form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                  #submitting inscription
                                  form.field_with(:name => 'dispatch').value = "inscrire"
                                  form.submit
                                else
                                end
                              end
                       elsif @tournament.category == '40 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 40"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '50 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 50"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '55 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 55"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '60 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 60"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '70 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 70"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '75 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 75"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '80 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 80"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '13-14 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 13/14 ans"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '15-16 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 15/16 ans"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '17-18 ans' && @tournament.genre == 'male'
                          categories.each do |category|
                              if category.text == "Simple Messieurs 17/18 ans"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end

                        elsif @tournament.category == 'seniors' && @tournament.genre == 'female'
                          categories.each do |category|
                            if category.text == "Simple Dames Senior"
                              form.checkbox_with(:name => 'epr_iid_selection[1]').check
                              #submitting inscription
                              form.field_with(:name => 'dispatch').value = "inscrire"
                              form.submit
                            else
                            end
                          end
                       elsif @tournament.category == '45 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 45"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '35 ans' && @tournament.genre == 'female'
                            categories.each do |category|
                                if category.text == "Simple Dames 35"
                                  form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                  #submitting inscription
                                  form.field_with(:name => 'dispatch').value = "inscrire"
                                  form.submit
                                else
                                end
                              end
                       elsif @tournament.category == '40 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 40"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '50 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 50"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '55 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 55"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '60 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 60"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '70 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 70"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '75 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 75"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '80 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 80"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '13-14 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 13/14 ans"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '15-16 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 15/16 ans"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                            end
                        elsif @tournament.category == '17-18 ans' && @tournament.genre == 'female'
                          categories.each do |category|
                              if category.text == "Simple Dames 17/18 ans"
                                form.checkbox_with(:name => 'epr_iid_selection[1]').check
                                #submitting inscription
                                form.field_with(:name => 'dispatch').value = "inscrire"
                                form.submit
                              else
                              end
                          end
                        end
                    end

                    flash[:alert] = "L'export s'est passé comme sur des roulettes"
                    # redirect_to tournament_subscriptions_path(@tournament)
                else
                  raise
                  flash[:alert] = "Le numéro d'homologation n'a pas été reconnu" #va me le faire a chaque fois
                # redirect_to tournament_subscriptions_path(@tournament)
                # return
                end
              end
          else
            flash[:alert] = "Votre identifiant ou votre mot de passe AEI ne sont pas valables"
          end
        end
        redirect_to tournament_subscriptions_path(@tournament)
    end
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:tournament_id])
    custom_authorize AEIExportPolicy, @tournament
  end
end