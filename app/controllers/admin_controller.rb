class AdminController < ApplicationController
  before_action :require_admin , only: [:admin, :pins]
  def index

  end
  def pins
@sellers = User.where(seller: true)

 if @sellers.update(:pins =>((User.where(username: params[:username])).last.pins + params[:Npins]))
else
render 'admin/pins'
# @newpins = @seller.pins + params[:Npins]
# @x = @seller.update(:pins => @newpins)
#@sellers.save
end
  end

  private
  def require_admin



    if current_user.admin != true
      redirect_to root_path
    end
  end
end