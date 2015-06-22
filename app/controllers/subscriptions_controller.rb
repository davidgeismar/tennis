class SubscriptionsController < ApplicationController
  skip_after_action :verify_authorized, only: [:mytournaments]


  def mytournaments
    @subscriptions = Subscription.where(user_id: current_user)
    #writte custom policy
  end


  def index
    @user = current_user
    @tournament     = Tournament.find(params[:tournament_id])
    @subscriptions  = @tournament.subscriptions
    authorize @subscriptions
    policy_scope(@subscriptions)
  end

  def refus_without_remboursement
     @subscription = Subscription.find(params[:subscription_id_refus_without_remboursement])
     authorize @subscription
     @subscription.status = "refused"
     @subscription.save
      redirect_to tournament_subscriptions_path(@subscription.tournament)
      flash[:notice] = "Vous avez bien désinscrit #{@subscription.user.full_name}. Celui-ci ne participe plus au tournoi"
  end

# method must trigger mangopay_payout on each subscription as soon as the tournament is completed
  def global_payout
    if @tournament.payment_option = true
      @tournament.subscriptions.where(status: confirmed).each do |subscription|
        mangopay_payout_global
      end
    end
  end

  # pas possible de faire un refund car payout déjà éxécuté
  # pas possible de créer un nouveau transfert ! il faudrait demander le numéro de carte du JA
  # seul solution faire les payout 2 jours après la fin du tournoi
  # et bien faire des mangopay_refund

  def accept_player
     @subscription = Subscription.find(params[:subscription_id_accept_player])
     @subscription.status = "confirmed!"
     @subscription.save
     raise
     authorize @subscription
     redirect_to tournament_subscriptions_path(@subscription.tournament)
  end

  def refund
    @subscription = Subscription.find(params[:subscription_id_refund])
    if mangopay_refund
      @subscription.status = "refused"
      authorize @subscription
      @subscription.save
      @notification = Notification.new
      @notification.user = @subscription.user
      @notification.content = "Nous avons le regret de vous apprendre que le juge arbitre de #{@subscription.tournament.name} a finalement annulé votre inscription."
      #insérer mailer
      redirect_to tournament_subscriptions_path(@subscription.tournament)
      flash[:notice] = "Vous avez bien procédé au remboursement de #{@subscription.user.full_name}. Celui-ci ne participe plus au tournoi"
    else
      redirect_to tournament_subscriptions_path(@subscription.tournament)
      flash[:warning] = "Le remboursement n'a pas pu etre effectué. Merci de réessayer plus tard"
    end
  end

  def update
    @subscription = Subscription.find(params[:id])
    authorize @subscription
    @subscription.update(subscription_params)
    if @subscription.status == "refused"
      mangopay_refund
      @notification = Notification.new
      @notification.user = @subscription.user
      @notification.content = "Votre inscription à #{@subscription.tournament.name} a été refusé"
      @notification.save
      redirect_to tournament_subscriptions_path(@subscription.tournament)
    elsif @subscription.status == "canceled"
      mangopay_refund
      redirect_to tournament_subscriptions_path(@subscription.tournament)
    else
      # mangopay_payout pas de payout à la confirmation sinon pas possible de rembourser le joueur
      @notification = Notification.new
      @notification.user = @subscription.user
      @notification.content = "Votre inscription à #{@subscription.tournament.name} a été confirmé"
      @notification.save
      redirect_to tournament_subscriptions_path(@subscription.tournament)
    end
  end

  def new
    @subscription = Subscription.new(tournament_id: params[:tournament_id])
    authorize @subscription
  end

  def show
    @subscription = Subscription.find(params[:id])
    authorize @subscription
  end

  private

     def mangopay_user_attributes
      {
        'Email' => current_user.email,
        'FirstName' => current_user.first_name,
        'LastName' => current_user.last_name,  # TODO: Change this! Add 2 columns on users table.
        'Birthday' => current_user.birthday.to_i,  # TODO: Change this! Add 1 column on users table
        'Nationality' => 'FR',  # TODO: change this!
        'CountryOfResidence' => 'FR' # TODO: change this!
      }
    end
    def create_mangopay_natural_user_and_wallet
      natural_user = MangoPay::NaturalUser.create(mangopay_user_attributes)


      wallet = MangoPay::Wallet.create({
        Owners: [natural_user["Id"]],
        Description: "My first wallet",
        Currency: "EUR",
        })

      kyc_document = MangoPay::KycDocument.create(natural_user["Id"],{Type: "IDENTITY_PROOF", Tag: "Driving Licence"})

      self.mangopay_natural_user_id = natural_user["Id"]
      self.wallet_id = wallet["Id"]
      self.kyc_document_id = kyc_document["Id"]
      self.save
    end

    def mangopay_payin

      MangoPay::PayIn::Card::Direct.create({
          "Tag" => "Payment Carte Bancaire",
          "CardType" => "CB_VISA_MASTERCARD",
          "AuthorId" => current_user.mangopay_natural_user_id,
          "CreditedUderId" => current_user.mangopay_natural_user_id,
          "DebitedFunds" => {
            "Currency" => "EUR",
            "Amount" => amount.to_i*100
          },
          "Fees" => {
            "Currency" => "EUR",
            "Amount" => 0
          },
          "CreditedWalletID" => current_user.wallet_id,
          "SecureModeReturnURL" => mangopay_return_transfers_url(booking_id: params[:booking_id]),
          "CardId" => current_user.card_id,
          "CardType" => "CB_VISA_MASTERCARD",
          "Culture" => "FR",
          "SecureMode" => "DEFAULT"
        })
    end


    def mangopay_payout
      payout = MangoPay::PayOut::BankWire.create(payout_attributes)
      transfer = Transfer.create(:status => payout["Status"], :category => "payout", :mangopay_transaction_id => payout["Id"].to_i, :archive => payout, :tournament_id => @subscription.tournament)
      if payout["Status"] == 'CREATED'
        transfer.status = "payout"
        transfer.save
      elsif payout["Status"] == 'SUCCEEDED'
        transfer.status = 'succeeded'
        transfer.save
      end
    end


    def payout_attributes

      # subscription_id ???
      {
        'Tag' => "payout",
        'AuthorId' => @subscription.user.mangopay_natural_user_id,
        'DebitedFunds' => {
          Currency: "EUR",
          Amount: @subscription.tournament.amount*100*0.7
        },
        'Fees' => {
          Currency: "EUR",
          Amount: "0"
        },
        'DebitedWalletId' => @subscription.user.wallet_id,
        'BankAccountId' => @subscription.tournament.user.bank_account_id,
        'BankWireRef' => "Virement TennisMatch"
      }
    end

    def mangopay_refund
      @transfer = @subscription.tournament.transfers.where("archive ->> 'AuthorId' = ?", "#{@subscription.user.mangopay_natural_user_id}").first()
      MangoPay::PayIn.refund(@transfer.mangopay_transaction_id,{
          "AuthorId" => @subscription.user.mangopay_natural_user_id,
        })
    end

    def set_subscription
      @subscription.find(params[:id])
    end
    def subscription_params
      params.require(:subscription).permit(:status, :disponibilities)
    end

end
