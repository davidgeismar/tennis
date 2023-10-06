
source 'https://rubygems.org'

source 'https://rails-assets.org' do
  gem 'rails-assets-underscore'
end

ruby '2.2.3'

gem 'rails', '~> 7.1.0'

gem 'activeadmin',                github: 'activeadmin'
gem 'aws-sdk', '~> 2.0', '>= 2.0.22'
gem 'bootstrap-datepicker-rails', '~> 1.5.0'
gem 'bootstrap-sass',             '~> 3.3.3'
gem 'bootstrap-switch-rails'
gem 'geokit-rails', '>= 2.5.0'
gem 'devise', '~> 4.7.0'
gem 'devise-i18n',                '~> 0.11.3'
gem 'devise-i18n-views',          '~> 0.3.4'
gem 'devise_invitable', '~> 1.6.0'
gem 'enumerize',                  '~> 0.10.0'
gem 'figaro',                     '~> 1.1.0'
gem 'font-awesome-sass',          '~> 4.3.1'
gem 'fullcalendar-rails', '~> 2.4.0.0'
gem 'geocoder',                   '~> 1.2.7'
gem 'geocomplete_rails', '~> 1.7.0'
gem 'gmaps4rails',                '~> 2.1.2'
gem 'high_voltage',               '~> 2.2.1'
gem 'jquery-rails', '~> 4.1.0'
gem 'mangopay',                   '~> 3.0.18'
gem 'mechanize',                  '~> 2.7.3'
gem 'momentjs-rails', '~> 2.11.0'
gem 'omniauth-facebook',          '~> 3.0.0'
gem 'paperclip',                  '~> 4.2.1'
gem 'pg',                         '~> 0.18.1'
gem 'pg_search',                  '~> 1.0.5'
gem 'pundit',                     '~> 0.3.0'
gem 'rails-i18n', '~> 7.0.1'
gem 'rails_config',               '~> 0.4.2'
gem 'redcarpet',                  '~> 3.3.1'
gem 'sass-rails', '~> 5.0', '>= 5.0.8'
gem 'simple_form', '~> 4.0.0'
gem 'slim',                       '~> 3.0.6'
gem 'twilio-ruby',                '~> 3.12'
gem 'uglifier',                   '~> 2.7.0'
gem 'unicode_utils',              '~> 1.4.0'
# gem "sidekiq-cron",               '~> 0.3.0'
gem 'sinatra',                  :require => nil
gem 'appsignal',                  '~> 0.12.rc'
gem 'ruby-trello'
gem 'sidekiq',                    '~> 3.5.3' # scheduler works only with sidekiq ~> 3


gem 'google-analytics-rails'


group :development, :test do
  gem 'faker'
  gem 'iso-iban'
  gem 'rspec-rails', '>= 3.5.0'
  gem 'factory_girl_rails', '>= 4.6.0'
  gem 'annotate'
  gem 'better_errors', '>= 2.3.0'
  gem 'binding_of_caller'
  gem 'letter_opener'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'quiet_assets'
  gem 'spring'
end

group :test do
  gem 'capybara'
  gem 'guard-rspec'
  gem 'launchy'
end

group :production do
  gem 'puma'
  gem 'rack-timeout'
  gem 'rails_12factor'
end
