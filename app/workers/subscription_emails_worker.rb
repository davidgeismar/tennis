class SubscriptionEmailsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(subscription_ids)
    #emails
    subscriptions = Subscription.where(id: subscription_ids)

    SubscriptionMailer.confirmation(subscriptions).deliver
    SubscriptionMailer.confirmation_judge(subscriptions).deliver
    SubscriptionMailer.new_subscription(subscriptions).deliver

    #notifs
    subscriptions.each do |subscription|
      notification = Notification.create(
        user:       subscription.tournament.user,
        content:    "#{subscription.user.full_name} a demandé à s'inscrire à #{subscription.tournament.name} dans la catégorie #{subscription.competition.category} ",
        competition_id: subscription.competition.id
      )
    end
  end
end
