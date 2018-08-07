class WelcomeController < ApplicationController
  skip_before_action :authenticate_user! , only: [:index,:unconfirmed , :confirmed]
  before_action :require_admin , only: [:admin]
  def index
    @a = Category.last
    @announcements = @a.articles.last

    @e= Category.find("3")
    @events = @e.articles.last

    @m=Category.find("2")
    @maintenance = @m.articles.last


    @u= Category.first
    @updates = @u.articles.last
  end
  def confirmed
  end

  def unconfirmed
  end

  def admin

  end
  def download

  end
  private
  def require_admin



    if current_user.admin != true
      redirect_to root_path
    end
  end
end
