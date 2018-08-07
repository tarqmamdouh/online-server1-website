class User::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email,:name,:password, :password_confirmation, :terms_of_service])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email,:name,:password, :password_confirmation, :current_password])
  end

  protected
  def after_inactive_sign_up_path_for(resource)
    unconfirmed_path # Or :prefix_to_your_route
  end

end