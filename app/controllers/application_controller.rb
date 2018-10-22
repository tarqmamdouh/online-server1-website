class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_variables

  def set_variables
    @a = Category.find_by_name("Announcements")
    @announcements = @a.articles.all.last(3).reverse
  end

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
