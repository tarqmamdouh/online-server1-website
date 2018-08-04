class UsersController < ApplicationController
before_action :require_admin , only: [:mark_spam]
  def show
    @user = User.find_by_username(params[:username])
  end
  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  def show_u
    @user = User.find_by_username(params[:username])
  end
  def mark_spam
   @user = User.find_by_username(params[:username])
    @user.spam = true
    flash[:danger] = "You marked this user as spam!"
  end
  private
  def require_admin
    if current_user.admin != true
      redirect_to root_path
    end
  end
end