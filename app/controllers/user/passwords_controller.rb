require "SQL"
class User::PasswordsController < Devise::PasswordsController
  protected
  def after_resetting_password_path_for(resource)
    @DB = SQL.connect_account
    table = @DB[:TB_User]
    user_name = resource.username
    password = resource.encrypted_password
    table.where(:StrUserID => user_name).update(password: password)
    Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : new_session_path(resource_name)
  end
end