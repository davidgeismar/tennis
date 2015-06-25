 class TournamentsController < ApplicationController
  before_filter :set_tournament, only: [:invite_player_to_tournament, :update, :edit, :show, :invite_player, :registrate_card]
  skip_after_action :verify_authorized


  def AEIexport
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
        if html_body.search('td a.treeview2').first.present?
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
                  form.field_with(:name => 'dispatch').value = "selectionner"
                  # inscription page
                  page = form.submit
                  body = page.body
                  html_body = Nokogiri::HTML(body)
                  form = agent.page.forms.first

                  numbers = (0...total_subscriptions)

                  # checking all checkboxes for players
                  numbers.each do |number|
                    checkbox = form.checkbox_with(:name => 'pp_ino_selection['+ number.to_s + ']')

                    if checkbox.present?
                      checkbox.check
                    end
                  end

                  # need to code which category I have to select by checking the TM tournament category
                  # if @tournament.category = "senior"
                  # check xpath with text senior
                  # .parent.form.checkbox...
                  form.checkboxes.each do |checkbox|
                    td = checkbox.node.parent
                    tr = td.parent

                    category_title      = tr.search('td')[1].text
                    tournament_category = "#{@tournament.genre}_#{@tournament.category}"
                    aei_tournament_cat  = I18n.t("aei.tournament_category.#{tournament_category}")

                    if aei_tournament_cat == category_title
                      checkbox.check

                      # submitting inscription
                      form.field_with(:name => 'dispatch').value = "inscrire"
                      form.submit
                    end
                  end
                  checking_export()
                  # number_validated_subscriptions == array_validated_subscriptions.count
                end
                number_validated_subscriptions == array_validated_subscriptions.count
                flash[:notice] = "Vous avez exporté #{number_validated_subscriptions} avec succès"
                array_failed_subscriptions.each do |failed_subscription|
                  flash[:danger] = "#{failed_subscription.user.full_name} n'a pas pu être exporté. Merci de vous connecter sur AEI pour procéder à l'inscription manuelle"
                end
                # redirect_to tournament_subscriptions_path(@tournament)
              end
            end

            unless homologation_number_found
              raise
              flash[:danger] = "Le numéro d'homologation n'a pas été reconnu" #va me le faire a chaque fois
              # redirect_to tournament_subscriptions_path(@tournament)
              # return
            end
        else
          flash[:alert] = "Votre identifiant ou votre mot de passe AEI ne sont pas valables"
        end

      end

      redirect_to tournament_subscriptions_path(@tournament)
    end
  end

  def checking_export

    successfully_exported_players = []
    agent = Mechanize.new
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

        joueur_access = html_body.search('#tabs0head2 a').each do |a|
          lien_joueurs_inscrits = a[:href]
          page_joueurs_inscrits = agent.get(lien_joueurs_inscrits)
          body = page_joueurs_inscrits.body
          html_body = Nokogiri::HTML(body)
          valids = html_body.search('table.L1 table td.L2[2]').text
          array_subscribed_players =[]
          valids.each do |valid|
            array_subscribed_players  << valid.text.downcase.strip
          end
          array_validated_subscriptions =[]
          array_failed_subscriptions = []
          subscription_array.each do |subscription|
            if array_subscribed_players.include? '#{subscription.user.full_name.downcase.strip}'
              array_validated_subscriptions << subscription
              puts "SUCCESS"
            else
              array_failed_subscriptions << subscription
              puts "FAILURE"
            end
          end
        end
      end
    end
  end



  def index
    @tournaments = policy_scope(Tournament)
  end

  def show
    @markers = Gmaps4rails.build_markers(@tournament) do |tournament, marker|
      marker.lat tournament.latitude
      marker.lng tournament.longitude
    end
    authorize @tournament
  end

  def new
    if current_user.first_name.blank? || current_user.last_name.blank? || current_user.judge_number.blank? || current_user.telephone.blank? || current_user.birthdate.blank? || current_user.iban.blank? || current_user.bic.blank? || current_user.address.blank? || current_user.iban.blank? || current_user.bic.blank?
      flash[:alert] = "Vous devez d'abord remplir votre profil entièrement pour pouvoir ajouter votre tournoi"
      redirect_to 'judge_connected'
    else
      create_mangopay_natural_user_and_wallet
      create_mangopay_bank_account

      @tournament = Tournament.new
      authorize @tournament
    end
  end

  def create
    custom_homologation_number = params[:tournament][:homologation_number].split.join
    params[:tournament][:homologation_number] = custom_homologation_number
    @tournament = Tournament.new(tournament_params)
    authorize @tournament
    @tournament.user = current_user
    if @tournament.save
      redirect_to tournament_path(@tournament)
    else
      render 'new'
    end
  end

  def edit
    authorize @tournament
  end

  def update
    authorize @tournament
    @tournament.update(tournament_params)
    @tournament.accepted = false
    @tournament.save
  end

  def invite_player
    authorize @tournament
  end

  def invite_player_to_tournament
    authorize @tournament
    User.invite!(:email => params[:email], :name => params[:first_name] + " " + params[:last_name])
    @user = User.find_by(email: params[:email])
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.save
    @subscription = Subscription.new(user: @user, tournament: @tournament)
    if @subscription.save
      redirect_to tournament_subscriptions_path(@tournament)
    else
      render :invite_player
    end
  end


  def registrate_card


    authorize @tournament
    arrayminor = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans', '15-16 ans', '17-18 ans']
    arrayinf18 = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans', '15-16 ans']
    arrayinf16 = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans']
    arrayinf14 = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans']
    arrayinf12 = ['9 ans', '9-10ans', '10 ans', '11 ans']
    arrayinf11 = ['9 ans', '9-10ans', '10 ans']
    ranking_array = ['NC', '40', '30/5', '30/4', '30/3', '30/2', '30/1', '30', '15/5', '15/4', '15/3', '15/2', '15/1', '15', '5/6', '4/6', '3/6', '2/6', '1/6', '0', '-2/6', '-4/6', '-15', '-30']


    user_ranking_index = ranking_array.index(current_user.ranking)
    tournament_max_ranking_index = ranking_array.index(@tournament.max_ranking)
    tournament_min_ranking_index = ranking_array.index(@tournament.min_ranking)



    if current_user.first_name.blank? || current_user.last_name.blank? || current_user.licence_number.blank? || current_user.telephone.blank? || current_user.birthdate.blank? || current_user.club.blank? || current_user.genre.blank?
      flash[:alert] = "Vous devez d'abord remplir votre profil entièrement avant de pouvoir vous inscrire à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif user_ranking_index < tournament_min_ranking_index
      flash[:alert] = "Vous n'avez pas le classement requis pour vous inscrire dans ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif user_ranking_index > tournament_max_ranking_index
      flash[:alert] = "Vous n'avez pas le classement requis pour vous inscrire dans ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif current_user.subscriptions.where(tournament: @tournament) != []
      flash[:alert] = "Vous êtes déjà inscrit à ce tournoi"
      redirect_to tournament_path(@tournament)

    elsif current_user.genre != @tournament.genre
      flash[:alert] = "Ce tournoi n'est pas mixte. Vous ne pouvez pas vous inscrire."
      redirect_to tournament_path(@tournament)

    elsif arrayminor.include? "#{@tournament.category}" && current_user.age > 18

      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)

    elsif arrayinf18.include? "#{@tournament.category}" && 16<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)

    elsif arrayinf16.include? "#{@tournament.category}" && 14<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)

    elsif arrayinf14.include? "#{@tournament.category}" && 12<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)

    elsif arrayinf12.include? "#{@tournament.category}" && 11<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif arrayinf11.include? "#{@tournament.category}" && 10<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif @tournament.category == '9 ans' && 9<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif @tournament.category == '35 ans' && current_user.age < 35
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif @tournament.category == '40 ans' && current_user.age < 40
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif @tournament.category == '50 ans' && current_user.age < 50
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif @tournament.category == '55 ans' && current_user.age < 55
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif @tournament.category == '60 ans' && current_user.age < 60
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif @tournament.category == '70 ans' && current_user.age < 70
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif @tournament.category == '75 ans' && current_user.age < 75
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)
    elsif @tournament.category == '80 ans' && current_user.age < 80
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(@tournament)


    elsif current_user.mangopay_natural_user_id.blank?
      create_mangopay_natural_user_and_wallet
      card = MangoPay::CardRegistration.create({UserId: current_user.mangopay_natural_user_id, Currency:"EUR"})

      redirect_to new_tournament_subscription_path(
        access_key: card["AccessKey"],
        preregistration_data: card["PreregistrationData"],
        card_registration_url: card["CardRegistrationURL"],
        card_registration_id: card["Id"],
        tournament_id: params[:tournament_id])

    else
      card = MangoPay::CardRegistration.create({UserId: current_user.mangopay_natural_user_id, Currency:"EUR"})

      redirect_to new_tournament_subscription_path(
        access_key: card["AccessKey"],
        preregistration_data: card["PreregistrationData"],
        card_registration_url: card["CardRegistrationURL"],
        card_registration_id: card["Id"],
        tournament_id: params[:tournament_id])
    end
  end

  def find
    @tournament = Tournament.new
    authorize @tournament
  end

  private

  def set_tournament
    @tournament = Tournament.find(params[:id])
  end

  def create_mangopay_bank_account

      bank_account = MangoPay::BankAccount.create(current_user.mangopay_natural_user_id, mangopay_user_bank_attributes)
      current_user.bank_account_id = bank_account["Id"]
      current_user.save
      rescue MangoPay::ResponseError => e
        redirect_to root_path
        flash[:alert] = "L'Iban ou le Bic que vous avez fourni n'est pas valide. Veuillez vérifier les informations fournies. Si le problème persiste n'hésitez pas à contacter l'équipe TennisMatch."

   end

  def mangopay_user_bank_attributes
      {
        'OwnerName' => current_user.full_name,
        'Type' => "IBAN",
        'OwnerAddress' => current_user.address,
        'IBAN' => current_user.iban,
        'BIC' => current_user.bic,
        'Tag' => 'Bank Account for Payouts'
      }
  end

  def tournament_params
    params.require(:tournament).permit(:genre, :category, :amount, :starts_on, :ends_on, :address, :club_organisateur, :name, :city, :lat, :long, :homologation_number, :max_ranking, :min_ranking, :nature)
  end


  def create_mangopay_natural_user_and_wallet
    natural_user = MangoPay::NaturalUser.create(mangopay_user_attributes)


    wallet = MangoPay::Wallet.create({
      Owners: [natural_user["Id"]],
      Description: "My first wallet",
      Currency: "EUR",
      })

    kyc_document = MangoPay::KycDocument.create(natural_user["Id"],{Type: "IDENTITY_PROOF", Tag: "Driving Licence"})

    current_user.mangopay_natural_user_id = natural_user["Id"]
    current_user.wallet_id = wallet["Id"]
    current_user.kyc_document_id = kyc_document["Id"]
    current_user.save
  end

   def mangopay_user_attributes
    {
      'Email' => current_user.email,
      'FirstName' => current_user.first_name,
      'LastName' => current_user.last_name,  # TODO: Change this! Add 2 columns on users table.
      'Birthday' => current_user.birthdate.to_i,  # TODO: Change this! Add 1 column on users table
      'Nationality' => 'FR',  # TODO: change this!
      'CountryOfResidence' => 'FR' # TODO: change this!
    }
  end
end
