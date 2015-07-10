module SubscriptionsHelper
  def subscription_status_options
    Subscription.status.options.reject { |_text, value| value == "confirmed_warning" }
  end
end