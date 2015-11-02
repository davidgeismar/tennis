class TechMailer < ApplicationMailer
  def payout_error(tournament_id, subscription_error_ids)
    @tournament             = Tournament.find(tournament_id)
    @subscription_error_ids = subscription_error_ids

    mail(
      to:       'davidgeismar@wetennis.fr',
      subject:  "[WeTennis] Payout error: #{subscription_error_ids.size} errors"
    )
  end
end
