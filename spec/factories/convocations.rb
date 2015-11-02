require 'factory_girl_rails'

FactoryGirl.define do
  factory :convocation do |f|
    f.date { Faker::Date.between(2.days.ago, Date.today) }
    f.hour "17:00"
    f.subscription
    f.status ["pending", "confirmed", "refused", "confirmed_by_judge", "cancelled"].sample
  end
end

