require 'factory_girl_rails'

FactoryGirl.define do
  factory :contact do |f|
    f.content { Faker::Lorem.sentence }
    f.object { Faker::Lorem.sentence }
    f.email  { Faker::Internet.email }
  end
end
