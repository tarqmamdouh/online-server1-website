class UsersController < ApplicationController
  def show
    @user = User.find_by_username(params[:username])
  end
  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
end