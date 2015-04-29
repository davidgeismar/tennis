class TransfersController < ApplicationController

  def create
    tournament = Tournament.find(params[:tournament_id])
    judge = tournament.user
    player = current_user

    # discount = booking.discount_authorized

    # booking.attribute_coupons_to_self

      new_price = tournament.amount

    transfer = Transfer.create(:status => "pending", :category => "payin", tournament_id: params[:tournament_id]) #récupérer id de booking

    if new_price !=0
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
        "SecureModeReturnURL" => mangopay_return_transfers_url(tournament_id: params[:tournament_id]),
        "CardId" => player.card_id,
        "CardType" => "CB_VISA_MASTERCARD",
        "Culture" => "FR",
        "SecureMode" => "DEFAULT"
      })

      if @payin["SecureModeNeeded"]
        respond_to do |format|
          format.html {redirect_to @payin["SecureModeRedirectURL"] }
          format.js {render :js => "window.location.href='"+@payin["SecureModeRedirectURL"]+"'"}
        end
      else
        respond_to do |format|
          format.html {redirect_to mangopay_return_transfers_url(tournament_id: params[:tournament_id], transactionId: @payin["Id"]) }
          format.js {render :js => "window.location.href='"+mangopay_return_transfers_url(tournament_id: params[:tournament_id], transactionId: @payin["Id"])+"'"}
        end
      end


    else
      transfer.destroy
      difference = booking.user.discount_available - booking.price
      booking.after_payment_update
      booking.coupons_payment_and_update
      UserCoupon.create(user_id: booking.user.id, amount: difference.to_i, category: "credit" )
      respond_to do |format|
        format.html {redirect_to success_transfer_path(booking.transfers.last) }
        format.js {render :js => "window.location.href='"+success_transfer_path(booking.transfers.last)+"'"}
      end
    end
  end
end

def mangopay_return
    payin = MangoPay::PayIn.fetch(params[:transactionId])
    to = Booking.where(:id => params[:tournament_id]).last
    user = booking.user
    transfer = Transfer.where(:tournament_id => params[:tournament_id], :category => "payin").last
    # coupon_discount = Transfer.where(:tournament_id => params[:tournament_id], :category => "coupon").last
    if payin["Status"] == "SUCCEEDED"
      booking.update_after_payin_success(payin)
      card = Trello::Card.find(booking.trello_card_id)
      card.due = booking.starts_on.to_date
      if booking.user_coupons.count != 0
        booking.coupons_payment_and_update
      end
      UserMailer.transfer_done_owner(booking).deliver
      UserMailer.transfer_done_tenant(booking).deliver
      booking.update_trello_attachment("Licence.jpg")
      redirect_to success_transfer_path(transfer)
    else
      transfer.update({:mangopay_transaction_id => params[:transactionId], :status => "failed"})
      redirect_to conversation_path(booking.conversation)
    end
  end


