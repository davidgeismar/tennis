require 'factory_girl_rails'

FactoryGirl.define do
  factory :user do |f|
    f.first_name { Faker::Lorem.sentence }
    f.last_name { Faker::Lorem.sentence }
    f.licence_number { Faker::Lorem.sentence }
    f.email  { Faker::Internet.email }
  end
end
