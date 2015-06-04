class TournamentsController < ApplicationController
  skip_after_action :verify_authorized, only: [:invite_player, :invite_player_to_tournament, :registrate_card, :success_payment, :new]
  def index
    @tournaments = policy_scope(Tournament)
  end

  def show
    @tournament = Tournament.find(params[:id])
    @markers = Gmaps4rails.build_markers(@tournament) do |tournament, marker|
      marker.lat tournament.latitude
      marker.lng tournament.longitude
    end
    authorize @tournament
  end

  def new
    if current_user.first_name.blank? || current_user.last_name.blank? || current_user.judge_number.blank? || current_user.telephone.blank? || current_user.birthdate.blank? || current_user.iban.blank? || current_user.bic.blank? || current_user.address.blank? || current_user.iban.blank? || current_user.bic.blank?
      flash[:alert] = "Vous devez d'abord remplir votre profil pour pouvoir ajouter votre tournoi"
      redirect_to 'judge_connected'
    else
      create_mangopay_natural_user_and_wallet
      create_mangopay_bank_account

      @tournament = Tournament.new
      authorize @tournament
    end
  end

  def create
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
    @tournament = Tournament.find(params[:id])
    authorize @tournament
  end

  def update
    @tournament = Tournament.find(params[:id])
    authorize @tournament
    @tournament.update(tournament_params)
  end

  def invite_player
    @tournament = Tournament.find(params[:id])
  end

  def invite_player_to_tournament
    @tournament = Tournament.find(params[:id])
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

  def success_payment
    @tournament = Tournament.find(params[:tournament_id])
  end

  def registrate_card

    arrayminor = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans', '15-16 ans', '17-18 ans']
    arrayinf18 = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans', '15-16 ans']
    arrayinf16 = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans', '13-14 ans']
    arrayinf14 = ['9 ans', '9-10ans', '10 ans', '11 ans', '11-12 ans', '12 ans']
    arrayinf12 = ['9 ans', '9-10ans', '10 ans', '11 ans']
    arrayinf11 = ['9 ans', '9-10ans', '10 ans']
    tournament = Tournament.find(params[:tournament_id])

    if current_user.first_name.blank? || current_user.last_name.blank? || current_user.licence_number.blank? || current_user.telephone.blank? || current_user.birthdate.blank? || current_user.club.blank? || current_user.genre.blank?
      flash[:alert] = "Vous devez d'abord remplir votre profil pour pouvoir vous inscrire à ce tournoi"
      redirect_to tournament_path(tournament)

    elsif current_user.genre != tournament.genre
      flash[:alert] = "Ce tournoi n'est pas mixte. Vous ne pouvez pas vous inscrire."
      redirect_to tournament_path(tournament)


    elsif current_user.subscriptions(tournament_id: tournament) != []
      flash[:alert] = "Vous etes déjà inscrit à ce tournoi"
      redirect_to tournament_path(tournament)

    elsif arrayminor.include? "#{tournament.category}" && current_user.age > 18

      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)

    elsif arrayinf18.include? "#{tournament.category}" && 16<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)

    elsif arrayinf16.include? "#{tournament.category}" && 14<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)

    elsif arrayinf14.include? "#{tournament.category}" && 12<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)

    elsif arrayinf12.include? "#{tournament.category}" && 11<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif arrayinf11.include? "#{tournament.category}" && 10<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif tournament.category == '9 ans' && 9<current_user.age
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif tournament.category == '35 ans' && current_user.age < 35
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif tournament.category == '40 ans' && current_user.age < 40
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif tournament.category == '50 ans' && current_user.age < 50
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif tournament.category == '55 ans' && current_user.age < 55
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif tournament.category == '60 ans' && current_user.age < 60
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif tournament.category == '70 ans' && current_user.age < 70
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif tournament.category == '75 ans' && current_user.age < 75
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)
    elsif tournament.category == '80 ans' && current_user.age < 80
      flash[:alert] = "Vous ne pouvez pas vous inscrire dans ces catégories"
      redirect_to tournament_path(tournament)


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
    params.require(:tournament).permit(:genre, :category, :amount, :starts_on, :ends_on, :address, :club_organisateur, :name, :city, :lat, :long)
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
