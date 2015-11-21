class ApplicationController < ActionController::Base
  include Pundit


  protect_from_forgery with: :exception

  before_action :authenticate_user!, unless: :pages_controller_or_contacts_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?



  after_action :verify_authorized,    except: :index, unless: :devise_or_pages_or_active_admin_controller?
  after_action :verify_policy_scoped, only:   :index, unless: :devise_or_pages_or_active_admin_controller?

 rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

   def after_sign_in_path_for(user)
    if !user.profile_complete?
      stored_location_for(user) || tournaments_path
    elsif user.judge == false
      stored_location_for(user) || tournaments_path
    else
      root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :judge
    devise_parameter_sanitizer.for(:accept_invitation) do |u|
    u.permit(:first_name, :last_name, :phone, :password, :password_confirmation,
             :invitation_token)
    end
  end

  def custom_authorize(policy_class, record = {})
    @_policy_authorized = true
    policy    = custom_policy(policy_class, record)
    predicate = "#{action_name}?"

    unless policy.public_send(predicate)
      raise NotAuthorizedError.new
    end
  end

  def custom_policy(policy_class, record, user=current_user)
    policy_class.new(user, record)
  end

  private

  def user_not_authorized
    flash[:alert] = I18n.t('controllers.application.user_not_authorized', default: "Vous n'avez pas accès à cette page")
    redirect_to(root_path)
  end

  def devise_or_pages_or_active_admin_controller?
    devise_controller? || pages_controller_or_contacts_controller? || params[:controller] =~ /^admin/
  end

  def pages_controller_or_contacts_controller?
    controller_name == "pages" || controller_name == "contacts"  # Brought by the `high_voltage` gem
  end
end
