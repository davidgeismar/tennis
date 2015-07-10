 class TournamentsController < ApplicationController
  before_filter :set_tournament, only: [:update, :edit, :show, :registrate_card]
  skip_after_action :verify_authorized

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

  def create #must create a different tournament for each checkbox that is selected
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

    # elsif user_ranking_index < tournament_min_ranking_index
    #   flash[:alert] = "Vous n'avez pas le classement requis pour vous inscrire dans ce tournoi"
    #   redirect_to tournament_path(@tournament)

    # elsif user_ranking_index > tournament_max_ranking_index
    #   flash[:alert] = "Vous n'avez pas le classement requis pour vous inscrire dans ce tournoi"
    #   redirect_to tournament_path(@tournament)

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
    params.require(:tournament).permit(:genre, :category, :amount, :starts_on, :ends_on, :address, :club_organisateur, :name, :city, :lat, :long, :homologation_number, :max_ranking, :min_ranking, :nature, :postcode, :young_fare)
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
