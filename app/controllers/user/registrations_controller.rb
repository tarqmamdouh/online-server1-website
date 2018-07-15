class User::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email,:birthdate,:password, :password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :email,:birthdate,:password, :password_confirmation, :current_password])
  end
end