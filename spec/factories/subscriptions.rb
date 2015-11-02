require 'factory_girl_rails'

FactoryGirl.define do
  factory :subscription do |f|
    f.user
    f.status ["pending", "confirmed", "confirmed_warning", "refused"].sample
    f.fare_type  ["standard", "young", "unknown"].sample
    f.tournament
    f.competition
    f.exported [true, false].sample
  end
end



