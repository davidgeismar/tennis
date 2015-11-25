require 'sidekiq'
require 'sidekiq/web'


Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == ["david", "4010a37121289"]
end


