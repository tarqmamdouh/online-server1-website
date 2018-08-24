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
      name = resource.name
      country = request.location.country
      ip = request.ip
      regtime = resource.updated_at.strftime("%Y-%m-%dT%H:%M:%S")

      if country.present?
        @DB[:TB_User].insert(StrUserID: user_name, password: password, Email: email, Name: name, sec_primary: 3, sec_content: 3, regtime: regtime, Country: country, reg_ip: ip)
      else
        @DB[:TB_User].insert(StrUserID: user_name, password: password, Email: email, Name: name, sec_primary: 3, sec_content: 3, regtime: regtime )
      end

      confirmed_path
    end
  end
end