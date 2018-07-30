class WelcomeController < ApplicationController
  skip_before_action :authenticate_user! , only: [:index,:unconfirmed , :confirmed]
  before_action :require_admin , only: [:admin]
  def index

  end
  def confirmed

  end
  def unconfirmed

  end
  def admin

  end
  private
  def require_admin
    if current_user.admin != true
      redirect_to root_path
    end
  end
end
