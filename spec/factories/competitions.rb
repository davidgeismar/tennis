require 'factory_girl_rails'

FactoryGirl.define do
  factory :competition do |f|
    f.tournament
    f.category Settings.enumerize.categories.sample
    # f.min_ranking
    # f.max_ranking
    f.nature "Simple"
    f.genre Settings.enumerize.genre.sample
  end
end


