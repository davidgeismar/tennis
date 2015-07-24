ActiveAdmin.register Tournament do

 permit_params :accepted, :genre, :category, :amount, :starts_on, :ends_on, :city, :user_id, :address, :name, :club_organisateur, :latitude, :longitude, :homologation_number, :max_ranking, :min_ranking, :nature, :postcode, :young_fare, :NC, :quarante, :trentecinq, :trentequatre, :trentetrois, :trentedeux, :trenteun, :trente, :quinzecinq, :quinzequatre, :quinzetrois, :quinzedeux, :quinzeun, :quinze, :cinqsix, :quatresix, :troissix, :deuxsix, :unsix, :zero, :moinsdeuxsix, :moinsquatresix, :moinsquinze, :moinstrente, :total, :iban, :bic
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end



end
