ActiveAdmin.register Tournament do
  permit_params :accepted,
                :address,
                :amount,
                :bic,
                :category,
                :cinqsix,
                :city,
                :club_email,
                :club_organisateur,
                :deuxsix,
                :ends_on,
                :funds_received,
                :genre,
                :homologation_number,
                :iban,
                :latitude,
                :longitude,
                :max_ranking,
                :min_ranking,
                :moinsdeuxsix,
                :moinsquatresix,
                :moinsquinze,
                :moinstrente,
                :name,
                :nature,
                :NC,
                :postcode,
                :quarante,
                :quatresix,
                :quinze,
                :quinzecinq,
                :quinzedeux,
                :quinzequatre,
                :quinzetrois,
                :quinzeun,
                :starts_on,
                :total,
                :trente,
                :trentecinq,
                :trentedeux,
                :trentequatre,
                :trentetrois,
                :trenteun,
                :troissix,
                :unsix,
                :user_id,
                :young_fare,
                :zero,
                :club_fare,
                :region

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
