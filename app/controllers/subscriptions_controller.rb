class SubscriptionsController < ApplicationController
skip_after_action :verify_authorized, only: [:create, :mytournaments]



  def create_mangopay_bank_account
    bank_account = MangoPay::BankAccount.create(mangopay_user_id, mangopay_user_bank_attributes)
    self.bank_account_id = bank_account["Id"]
    self.save
  end

  def mangopay_user_bank_attributes
    {
      'OwnerName' => current_user.name,
      'Type' => "IBAN",
      'OwnerAddress' => current_user.address,
      'IBAN' => current_user.iban,
      'BIC' => current_user.bic,
      'Tag' => 'Bank Account for Payouts'
    }
  end

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

  def mytournaments
    @subscriptions = Subscription.where(user_id: current_user)
  end

  # def accepted_payment
  #   @subscription = Subscription.new(tournament_id)
  # end

  def index
    @tournament     = Tournament.find(params[:tournament_id])
    @subscriptions  = @tournament.subscriptions
    policy_scope(@subscriptions)
  end

  def update
    @subscription = Subscription.find(params[:id])
    authorize @subscription
    @subscription.update(subscription_params)
    if @subscription.status == "refused"
      mangopay_refund
      redirect_to tournament_subscriptions_path(@subscription.tournament)
    else
      mangopay_payout
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

  def create
    tournament = Tournament.find(params[:tournament_id])
    @subscription.save
    redirect_to tournament_subscription_path(tournament, @subscription)
  end


  private

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
      judge = @subscription.tournament.user
      if judge.iban.blank?
        # UserMailer.new_iban_request(owner).deliver
        self.status = 'iban'
      else
        if judge.bank_account_id.blank?
          self.create_bank_account
        end
        unless car.user.bank_account_id.blank?
          payout = MangoPay::PayOut::BankWire.create(payout_attributes)
          transfer = self.transfers.create(:status => payout["Status"], :category => "payout", :mangopay_transaction_id => payout["Id"].to_i, :archive => payout)
          if payout["Status"] == 'CREATED'
            self.status = "payout"
          elsif payout["Status"] == 'SUCCEEDED'
            self.status = 'succeeded'
          end
        end
      end
      self.save
    end

    def payout_attributes
      {
        'Tag' => "payout",
        'AuthorId' => @subscription.user.mangopay_natural_user_id,
        'DebitedFunds' => {
          Currency: "EUR",
          Amount: self.price.to_i*100*0.7
        },
        'Fees' => {
          Currency: "EUR",
          Amount: "0"
        },
        'DebitedWalletId' => @subscription.user.wallet_id,
        'BankAccountId' => current_user.bank_account_id,
        'BankWireRef' => "Virement Roadstr"
      }
    end

    def mangopay_refund
      ActiveSupport::JSON.decode(your_json_string)
      @transfer = @subscription.tournament.transfers.where(archive: {"AuthorId" => @subscription.user.mangopay_natural_user_id})
      MangoPay::PayIn.refund(@transfer.mangopay_transaction_id,{
          "AuthorId" => @subscription.user.mangopay_natural_user_id,
        })
    end

    def set_subscription
      @subscription.find(params[:id])
    end
    def subscription_params
      params.require(:subscription).permit(:status)
    end

end
