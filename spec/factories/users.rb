require 'factory_girl_rails'

FactoryGirl.define do
  factory :user do |f|
    f.first_name { Faker::Name.first_name}
    f.last_name { Faker::Name.last_name }
    f.password { Faker::Internet.password}
    f.licence_number { Faker::Lorem.sentence }
    f.email  { Faker::Internet.email }
    f.judge [true, false].sample
  end
end
