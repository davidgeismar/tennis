# class PaymentsWorker
#   include Sidekiq::Worker
#   def perform(name, count)
#     # do something
#   end
# end


# Sidekiq::Cron::Job.create(name: 'Payments worker - every day', cron: '*/5 * * * *', class: 'PaymentsWorker')

