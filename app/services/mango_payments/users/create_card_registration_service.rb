module MangoPayments
  module Users
    class CreateCardRegistrationService
      def initialize(user)
        @user = user
      end

      def call
        return MangoPay::CardRegistration.create(
          UserId:   @user.mangopay_user_id,
          Currency: 'EUR' # TODO: change this.
        )
      end
    end
  end
end
