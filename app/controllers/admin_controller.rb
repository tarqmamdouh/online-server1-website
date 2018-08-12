class AdminController < ApplicationController
  before_action :require_admin , only: [:admin, :pins]
  def index

  end

  def pins
    @sellers = User.where(:seller => true)
  end

  def add_pins
    @sellers = User.where(:seller => true)
    if params[:Npins].to_f<0
      flash[:danger]= "You can enter positive amount only"
      render 'admin/pins'
    else

    @seller = User.find_by_username(params[:username])
    new_pins = @seller.pins + params[:Npins].to_f
    if @seller.update_attribute(:pins, new_pins)
      flash[:success] = "Succefully Added"
    else
      render 'admin/pins'
    end
      end
  end

  private
  def require_admin
    if current_user.admin != true
      redirect_to root_path
    end
  end
end