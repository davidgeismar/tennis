require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/scheduler'

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["david", "4010a37121289"]
end

Sidekiq.schedule = YAML.load_file(Rails.root.join("config/scheduler.yml"))
