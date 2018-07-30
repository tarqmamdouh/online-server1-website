class ApplicationController < ActionController::Base
  before_action :authenticate_user!
protected
  def after_sign_in_path_for(resource)
    if (current_user.admin?)
     admin_path
        ### your redirection ###
    else
      root_path
    ### other redirection ###
    end
  end
end
