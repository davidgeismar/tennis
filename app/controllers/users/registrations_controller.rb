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
end