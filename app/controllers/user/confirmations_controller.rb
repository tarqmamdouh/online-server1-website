require "SQL"
class User::ConfirmationsController < Devise::ConfirmationsController
  protected
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      #new_session_path(resource_name)
      @DB = SQL.connect_account

      #prepare sql paramaters

      user_name = resource.username
      password = resource.encrypted_password
      email = resource.email
      @DB[:TB_User].insert(StrUserID: user_name, password: password, Email: email)
      confirmed_path
    end
  end
end