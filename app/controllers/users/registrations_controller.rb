module Users
  class RegistrationsController < Devise::RegistrationsController
    def respond_with(*resources, &block)
      resource = resources.first

      if resource && resource.new_record? && resource.judge
        @user = resource
        render 'judges/show'
      else
        super(*resources, &block)
      end
    end
  end
   private

  # def sign_up_params
  #   params.require(:user).permit(:first_name, :last_name, :email, :password, :date_of_birth)
  # end

  # def account_update_params
  #   params.require(:user).permit(:first_name, :last_name, :email, :password, :date_of_birth)
  # end
end