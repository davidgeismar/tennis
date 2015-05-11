class TransfersController < ApplicationController
skip_after_action :verify_authorized
  def create
    tournament = Tournament.find(params[:tournament_id])
    judge = tournament.user
    player = current_user

    # discount = booking.discount_authorized

    # booking.attribute_coupons_to_self

      new_price = tournament.amount

    transfer = Transfer.create(:status => "pending", :category => "payin", tournament_id: params[:tournament_id]) #récupérer id de booking

      @payin = MangoPay::PayIn::Card::Direct.create({
        "Tag" => "Payment Carte Bancaire",
        "CardType" => "CB_VISA_MASTERCARD",
        "AuthorId" => player.mangopay_natural_user_id,
        "CreditedUserId" => judge.mangopay_natural_user_id,
        "DebitedFunds" => {
          "Currency" => "EUR",
          "Amount" => new_price.to_i*100
        },
        "Fees" => {
          "Currency" => "EUR",
          "Amount" => new_price.to_i*30
        },
        "CreditedWalletID" => judge.wallet_id,
        "SecureModeReturnURL" => "http://wwww.google.fr",
        "CardId" => player.card_id,
        "CardType" => "CB_VISA_MASTERCARD",
        "Culture" => "FR",
        "SecureMode" => "DEFAULT"
      })



      transfer.archive = @payin
      transfer.save
        respond_to do |format|
          format.html {redirect_to mangopay_return_transfers_url(tournament_id: params[:tournament_id], transactionId: @payin["Id"]) }
          format.js {render :js => "window.location.href='"+mangopay_return_transfers_url(tournament_id: params[:tournament_id], mangopay_transaction_id: @payin["Id"])+"'"}
        end
   end


  def mangopay_return
      payin = MangoPay::PayIn.fetch(params[:mangopay_transaction_id])
      tournament = Tournament.find(params[:tournament_id])
      transfer = Transfer.where(:tournament_id => params[:tournament_id], :category => "payin").last
      # coupon_discount = Transfer.where(:tournament_id => params[:tournament_id], :category => "coupon").last
      if payin["Status"] == "SUCCEEDED"
        transfer.mangopay_transaction_id = payin["Id"]
        transfer.save
        subscription = Subscription.create(user_id: current_user.id, tournament_id: tournament.id)
        subscription.save
        # UserMailer.transfer_done_owner(booking).deliver
        # UserMailer.transfer_done_tenant(booking).deliver
        # booking.update_trello_attachment("Licence.jpg")
        redirect_to success_path(tournament)
      else
        transfer.update({:mangopay_transaction_id => params[:transactionId], :status => "failed"})
        redirect_to root_path
      end
    end
end

