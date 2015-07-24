module SubscriptionsHelper
  def subscription_status_options
    Subscription.status.options.reject { |_text, value| value == "confirmed_warning" }
  end
   def subscription_status_options_player_added_manualy
    Subscription.status.options.reject { |_text, value| value == "confirmed" }
  end
end