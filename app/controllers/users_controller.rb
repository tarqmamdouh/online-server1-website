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
        @myjob = "Not Joined yet"
      end

      inventory = @DB[:_Inventory].where(:charid => @info[:charid])
      inventoryforavatar = @DB[:_InventoryForAvatar].where(:charid => @info[:charid])

      # 0: EQUIP_SLOT_HELM
      # 1: EQUIP_SLOT_MAIL,
      # 2: EQUIP_SLOT_SHOULDERGUARD,
      # 3: EQUIP_SLOT_GAUNTLET,
      # 4: EQUIP_SLOT_PANTS,
      # 5: EQUIP_SLOT_BOOTS,
      # 6: EQUIP_SLOT_WEAPON,
      # 7: EQUIP_SLOT_SHIELD or ARROW,
      # 9: EQUIP_SLOT_EARRING,
      # 10: EQUIP_SLOT_NECKLACE,
      # 11: EQUIP_SLOT_L_RING,
      # 12: EQUIP_SLOT_R_RING,

      #-----------------------------------------------------------------------------
      @weapon = inventory.where(:slot => 6).all.last
      @weapon_id = @weapon[:itemid]
      @weapon_stats = @DB[:_Items].where(:id64 => @weapon[:itemid]).all.last
      @weapon = @DB[:_RefObjCommon].where(:id => @weapon_stats[:refitemid]).all.last
      @weapon_rarity = @DB[:_RefObjItem].where(:id => @weapon[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @shield = inventory.where(:slot => 7).all.last
      @shield_id = @shield[:itemid]
      @shield_stats = @DB[:_Items].where(:id64 => @shield[:itemid]).all.last
      @shield = @DB[:_RefObjCommon].where(:id => @shield_stats[:refitemid]).all.last
      @shield_rarity = @DB[:_RefObjItem].where(:id => @shield[:link]).all.last
      #-----------------------------------------------------------------------------


      #-----------------------------------------------------------------------------
      @helm = inventory.where(:slot => 0).all.last
      @helm_id = @helm[:itemid]
      @helm_stats = @DB[:_Items].where(:id64 => @helm[:itemid]).all.last
      @helm = @DB[:_RefObjCommon].where(:id => @helm_stats[:refitemid]).all.last
      @helm_rarity = @DB[:_RefObjItem].where(:id => @helm[:link]).all.last
      #-----------------------------------------------------------------------------


      #-----------------------------------------------------------------------------
      @mail = inventory.where(:slot => 1).all.last
      @mail_id = @mail[:itemid]
      @mail_stats = @DB[:_Items].where(:id64 => @mail[:itemid]).all.last
      @mail = @DB[:_RefObjCommon].where(:id => @mail_stats[:refitemid]).all.last
      @mail_rarity = @DB[:_RefObjItem].where(:id => @mail[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @shoulder = inventory.where(:slot => 2).all.last
      @shoulder_id = @shoulder[:itemid]
      @shoulder_stats = @DB[:_Items].where(:id64 => @shoulder[:itemid]).all.last
      @shoulder = @DB[:_RefObjCommon].where(:id => @shoulder_stats[:refitemid]).all.last
      @shoulder_rarity = @DB[:_RefObjItem].where(:id => @shoulder[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @gauntlet = inventory.where(:slot => 3).all.last
      @gauntlet_id = @gauntlet[:itemid]
      @gauntlet_stats = @DB[:_Items].where(:id64 => @gauntlet[:itemid]).all.last
      @gauntlet = @DB[:_RefObjCommon].where(:id => @gauntlet_stats[:refitemid]).all.last
      @gauntlet_rarity = @DB[:_RefObjItem].where(:id => @gauntlet[:link]).all.last

      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @pants = inventory.where(:slot => 4).all.last
      @pants_id = @pants[:itemid]
      @pants_stats = @DB[:_Items].where(:id64 => @pants[:itemid]).all.last
      @pants = @DB[:_RefObjCommon].where(:id => @pants_stats[:refitemid]).all.last
      @pants_rarity = @DB[:_RefObjItem].where(:id => @pants[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @boots = inventory.where(:slot => 5).all.last
      @boots_id = @boots[:itemid]
      @boots_stats = @DB[:_Items].where(:id64 => @boots[:itemid]).all.last
      @boots = @DB[:_RefObjCommon].where(:id => @boots_stats[:refitemid]).all.last
      @boots_rarity = @DB[:_RefObjItem].where(:id => @boots[:link]).all.last
      #-----------------------------------------------------------------------------


      #-----------------------------------------------------------------------------
      @earring = inventory.where(:slot => 9).all.last
      @earring_id = @earring[:itemid]
      @earring_stats = @DB[:_Items].where(:id64 => @earring[:itemid]).all.last
      @earring = @DB[:_RefObjCommon].where(:id => @earring_stats[:refitemid]).all.last
      @earring_rarity = @DB[:_RefObjItem].where(:id => @earring[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @necklace = inventory.where(:slot => 10).all.last
      @necklace_id = @necklace[:itemid]
      @necklace_stats = @DB[:_Items].where(:id64 => @necklace[:itemid]).all.last
      @necklace = @DB[:_RefObjCommon].where(:id => @necklace_stats[:refitemid]).all.last
      @necklace_rarity = @DB[:_RefObjItem].where(:id => @necklace[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @lring = inventory.where(:slot => 11).all.last
      @lring_id = @lring[:itemid]
      @lring_stats = @DB[:_Items].where(:id64 => @lring[:itemid]).all.last
      @lring = @DB[:_RefObjCommon].where(:id => @lring_stats[:refitemid]).all.last
      @lring_rarity = @DB[:_RefObjItem].where(:id => @lring[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @rring = inventory.where(:slot => 12).all.last
      @rring_id = @rring[:itemid]
      @rring_stats = @DB[:_Items].where(:id64 => @rring[:itemid]).all.last
      @rring = @DB[:_RefObjCommon].where(:id => @rring_stats[:refitemid]).all.last
      @rring_rarity = @DB[:_RefObjItem].where(:id => @rring[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @job = inventory.where(:slot => 8).all.last
      @job_id = @job[:itemid]
      @job_stats = @DB[:_Items].where(:id64 => @job[:itemid]).all.last
      @job = @DB[:_RefObjCommon].where(:id => @job_stats[:refitemid]).all.last
      @job_rarity = @DB[:_RefObjItem].where(:id => @job[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @slot1 = inventoryforavatar.where(:slot => 0).all.last
      @slot1_id = @slot1[:itemid]
      @slot1_stats = @DB[:_Items].where(:id64 => @slot1[:itemid]).all.last
      @slot1 = @DB[:_RefObjCommon].where(:id => @slot1_stats[:refitemid]).all.last
      @slot1_rarity = @DB[:_RefObjItem].where(:id => @slot1[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @slot2 = inventoryforavatar.where(:slot => 1).all.last
      @slot2_id = @slot2[:itemid]
      @slot2_stats = @DB[:_Items].where(:id64 => @slot2[:itemid]).all.last
      @slot2 = @DB[:_RefObjCommon].where(:id => @slot2_stats[:refitemid]).all.last
      @slot2_rarity = @DB[:_RefObjItem].where(:id => @slot2[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @slot3 = inventoryforavatar.where(:slot => 2).all.last
      @slot3_id = @slot3[:itemid]
      @slot3_stats = @DB[:_Items].where(:id64 => @slot3[:itemid]).all.last
      @slot3 = @DB[:_RefObjCommon].where(:id => @slot3_stats[:refitemid]).all.last
      @slot3_rarity = @DB[:_RefObjItem].where(:id => @slot3[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @slot4 = inventoryforavatar.where(:slot => 3).all.last
      @slot4_id = @slot4[:itemid]
      @slot4_stats = @DB[:_Items].where(:id64 => @slot4[:itemid]).all.last
      @slot4 = @DB[:_RefObjCommon].where(:id => @slot4_stats[:refitemid]).all.last
      @slot4_rarity = @DB[:_RefObjItem].where(:id => @slot4[:link]).all.last
      #-----------------------------------------------------------------------------

      #-----------------------------------------------------------------------------
      @devil = inventoryforavatar.where(:slot => 4).all.last
      @devil_id = @devil[:itemid]
      @devil_stats = @DB[:_Items].where(:id64 => @devil[:itemid]).all.last
      @devil = @DB[:_RefObjCommon].where(:id => @devil_stats[:refitemid]).all.last
      @devil_rarity = @DB[:_RefObjItem].where(:id => @devil[:link]).all.last
      #-----------------------------------------------------------------------------

      @slots = []
      @slots << @slot1
      @slots << @slot2
      @slots << @slot3
      @slots << @slot4

      @sort_of_weapon = []
      @sort_of_weapon[2] = "Sword"
      @sort_of_weapon[3] = "Blade"
      @sort_of_weapon[4] = "Spear"
      @sort_of_weapon[5] = "Glaive"
      @sort_of_weapon[6] = "Bow"

      @sort_of_acc = []
      @sort_of_acc[1] = "Earring"
      @sort_of_acc[2] = "Necklace"
      @sort_of_acc[3] = "Ring"

      @sort_of_clothes = []
      @sort_of_clothes[1] = "Head"
      @sort_of_clothes[2] = "Shoulder"
      @sort_of_clothes[3] = "Chest"
      @sort_of_clothes[4] = "Legs"
      @sort_of_clothes[5] = "Hands"
      @sort_of_clothes[6] = "Foot"

      @type_of_clothes = []
      @type_of_clothes[1] = "Germant"
      @type_of_clothes[2] = "Protector"
      @type_of_clothes[3] = "Armor"

      @sox_types = []
      @sox_types[1] = "Seal of Star"
      @sox_types[2] = "Seal of Moon"
      @sox_types[0] = "Seal of Sun"
      #--------------------------- (( Logs )) ----------------------------#

      @DBB = SQL.connect_shardlog
      @lastUniqueKills = @DBB[:_LogEventUnique].where(:charid => @info[:charid], :killtype => 0).all.last(10).reverse
      @lastPVPKills = @DBB[:_LogEventCombat_PVP].where(:charid => @info[:charid], :deadcharid => @info[:charid] ).all.last(10).reverse
      @lastJOBKills = @DBB[:_LogEventCombat_JOB].where(:charid => @info[:charid], :deadcharid => @info[:charid] ).all.last(10).reverse
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