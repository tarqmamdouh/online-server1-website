class User::ConfirmationsController < Devise::ConfirmationsController
  protected
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      #new_session_path(resource_name)
      confirmed_path
    end
  end
end