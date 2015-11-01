require 'factory_girl_rails'

FactoryGirl.define do
  factory :tournament do |f|
    f.user
    f.accepted [true, false].sample
    f.amount  { Faker::Number.number(2) }
    f.starts_on { Faker::Date.between(2.days.ago, Date.today) }
    f.ends_on { Faker::Date.forward(23) }
    f.address {Faker::Address.street_address}
    f.city { Faker::Address.city }
    f.name { Faker::Company.name }
    f.club_organisateur { Faker::Company.name }
    f.homologation_number {Faker::Company.swedish_organisation_number}
    f.postcode { Faker::Address.postcode }
    f.young_fare { Faker::Number.number(2) }
    f.iban {"FR" + rand(10**20).to_s}
    f.bic "AXABFRPP"
    f.club_email { Faker::Internet.email }
    f.region ["Alsace", "Aquitaine", "Auvergne", "Basse-Normandie", "Bourgogne", "Bretagne", "Centre", "Champagne-Ardenne", "Corse", "Franche-Comté",
              "Haute-Normandie", "Île-de-France","Languedoc-Roussillon", "Limousin", "Lorraine", "Midi-Pyrénées", "Nord-Pas-de-Calais", "Pays de la Loire", "Picardie","Poitou-Charentes", "Provence-Alpes-Côte d'Azur",
              "Rhône-Alpes"].sample
  end
end
