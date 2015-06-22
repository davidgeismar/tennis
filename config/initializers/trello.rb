require 'trello'

Trello.configure do |config|
  config.developer_public_key = ENV['PUBLIC_TRELLO_KEY']
  config.member_token = ENV['MEMBER_TRELLO_TOKEN']
end