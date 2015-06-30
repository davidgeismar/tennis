require 'rubygems'
require 'twitter'
# load 'twitter_config.rb'


Twitter.configure do |config|
  config.consumer_key = "5E0gpJxMrDIG3xktouBETbmqh"
  config.consumer_secret = "mkQGwIR7nGUDGq1Q4S5DR3xJaa8YmI91fzhZMw6syusVKHOBTX"
  config.oauth_token = YOUR_OAUTH_TOKEN
  config.oauth_token_secret = YOUR_OAUTH_TOKEN_SECRET
end

def twitter_robot
result = Twitter.search("to:justinbieber marry me", :count => 1, :result_type => "recent")

result.class
# Twitter::SearchResults

result.statuses[0].user.screen_name
# 4ever_beliebing
end

twitter_robot()
