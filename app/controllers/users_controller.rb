require'SQL'
class UsersController < ApplicationController
  before_action :require_admin , only: [:mark_spam,:unmark_spam]
  def show
    if params[:charname].length > 17 || params[:charname].include?("-")|| params[:charname].include?("/")|| params[:charname].include?("\\")|| params[:charname].include?("'")|| params[:charname].include?("\"")
      redirect_to root_path
    else
      @DB= SQL.connect_shard
      character = @DB[:_Char]
      @info = character.where(:CharName16 => params[:charname]).all.last
    end
  end
  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end
  def show_u
    @user = User.find_by_username(params[:username])
  end
  def mark_spam
    @user = User.find_by_username(params[:username])
    if @user.spam?
      @user.update(:spam => false)
      flash[:notice] = "You unmarked this user as spam!"
    else
      @user.update( :spam => true )
      flash[:danger] = "You marked this user as spam!"
    end
    redirect_to
  end
  def search
    if params[:search_param].blank?
      flash.now[:danger]="You have entered an empty search string"
    else
      @users = User.search(params[:search_param])
      @users = current_user.except_current_user(@users)
      flash.now[:danger]="No users match this search criteria" if @users.blank?
    end
    respond_to do |format|
      format.js{render partial: 'users/result'}
    end
  end
  def search_char
    if params[:search_param].blank?
      flash.now[:danger]="You have entered an empty search string"
    elsif params[:search_param].length > 17 || params[:search_param].include?("-")|| params[:search_param].include?("/")|| params[:search_param].include?("\\")|| params[:search_param].include?("'")|| params[:search_param].include?("\"")
      flash.now[:danger]= "You have entered invalid search string"

    else
      @DB= SQL.connect_shard
      character = @DB[:_Char]
      @chars = character.where(Sequel.like(:charname16, '%'+ params[:search_param]+'%')).all
      flash.now[:danger]="No characters match this search criteria" if @chars.blank?
    end
    respond_to do |format|
      format.js{render partial: 'users/resultchar'}
    end
  end
  private
  def require_admin
    if current_user.admin != true
      redirect_to root_path
    end
  end

end