require'SQL'
class UsersController < ApplicationController
  skip_before_action :authenticate_user! , only: [:search_char, :search]
  before_action :require_admin , only: [:mark_spam,:be_seller,:mark_supp]

  def show
    if params[:charname].length > 17 || params[:charname].include?("-")|| params[:charname].include?("/")|| params[:charname].include?("\\")|| params[:charname].include?("'")|| params[:charname].include?("\"")
      redirect_to root_path
    else
      @DB= SQL.connect_shard
      character = @DB[:_Char]
      @info = character.where(:CharName16 => params[:charname]).all.last
      guild = @DB[:_Guild]
      @gname= guild.where(:id => @info[:guildid]).all.last
      charjob = @DB[:_CharTrijob]
      @jobname= charjob.where(:charid => @info[:charid]).all.last
      if @jobname[:jobtype] == 1
        @myjob = "Trader"
      elsif @jobname[:jobtype] == 2
        @myjob = "Thief"
      elsif @jobname[:jobtype] == 3
        @myjob = "Hunter"
      else
        @myjob = "Not Joined yet!!"
      end
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
    redirect_to "/users/"+@user.username
  end

  def be_seller
    @user = User.find_by_username(params[:username])
    if @user.seller?
      @user.update(:seller => false)
      flash[:danger] = "You unmarked this user as seller!"
      @user.pins = 0
      @user.save
    else
      @user.update( :seller => true )
      flash[:success] = "You marked this user as seller!"
    end
    redirect_to "/users/"+@user.username
  end

  def mark_supp
    @user = User.find_by_username(params[:username])
    if @user.support?
      @user.update(:support => false)
      flash[:danger] = "You unmarked this user as supporter!"
    else
      @user.update( :support => true )
      flash[:success] = "You marked this user as supporter!"
    end
    redirect_to "/users/"+@user.username
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
      @chars = character.where(Sequel.like(:charname16, '%'+ params[:search_param]+'%',case_insensitive: true)).all.first(4)
      flash.now[:danger]="No characters match this search criteria" if @chars.blank?
    end
    respond_to do |format|
      format.js{render partial: 'users/result_char'}

    end
  end

  def preferences
    @a = Category.find_by_name("Announcements")
    @announcements = @a.articles.all.last(3).reverse
    # connecting to database
    acc = SQL.connect_account
    shard = SQL.connect_shard
    #loading characters
    user_info = acc[:TB_User].where(:StrUserID => current_user.username).all.last
    game_user_id = user_info[:jid]
    characters = shard[:_User].where(:UserJID => game_user_id).all
    @names = []
    characters.each do |character|
      char_name = shard[:_Char].where(:charid => character[:charid]).all.last
      @names << char_name[:charname16]
    end
    if current_user.seller?
      @all_codes = acc[:_EPINS].where(:CreatorJID => game_user_id).all
    end
    if current_user.support? || current_user.admin?
      @tickets = Ticket.all
    else
      @tickets = current_user.tickets
    end
  end

  # def withdraw_silk
  #   @seller = current_user
  #   @costpins = 0.1*(params[:Npins].to_f)
  #   @userpins = @seller.pins
  #   @usersilk = @seller.silk
  #   if @costpins > @userpins || @costpins < 0
  #     flash.now[:danger] = "You have entered wrong amount of silks!!"
  #     redirect_to user_preferences_path
  #   else
  #     @seller.silk = @usersilk + params[:Npins].to_i
  #     @seller.pins = @userpins - @costpins
  #     @seller.save
  #     flash.now[:success] = "Silks successfully added!!"
  #     redirect_to user_preferences_path
  #   end
  # end

  def send_reset_password_mail
    current_user.send(:send_reset_password_instructions)
    flash[:success] = "An email with reset password instructions has been sent, please check your Email in order to reset password"
    redirect_to user_preferences_path
  end

  private
  def require_admin
    if current_user.admin != true
      redirect_to root_path
    end
  end

  def require_seller
    if current_user.seller != true
      redirect_to root_path
    end
  end
end