module MangoPayments
  module Tournaments
    class CreateLegalUserService
      def initialize(tournament)
        @judge      = tournament.user
        @tournament = tournament
      end

      def call
        mango_user = MangoPay::LegalUser.create(
          Name:                                   @tournament.club_organisateur,
          Email:                                  @tournament.club_email,
          LegalPersonType:                        'ORGANIZATION',
          LegalRepresentativeFirstName:           @judge.first_name,
          LegalRepresentativeLastName:            @judge.last_name,
          LegalRepresentativeAdress:              @judge.address,
          LegalRepresentativeEmail:               @judge.email,
          LegalRepresentativeBirthday:            @judge.birthdate.to_i,
          LegalRepresentativeNationality:         'FR', # TODO: change this.
          LegalRepresentativeCountryOfResidence:  'FR'  # TODO: change this.
        )

        @tournament.mangopay_user_id = mango_user['Id']
        @tournament.save
      end
    end
  end
end
