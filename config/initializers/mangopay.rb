MangoPay.configure do |config|
  config.preproduction      = (ENV['MANGOPAY_PRODUCTION'] != "true")
  config.client_id          = ENV['MANGOPAY_CLIENT_ID']
  config.client_passphrase  = ENV['MANGOPAY_CLIENT_PASSPHRASE']
end
