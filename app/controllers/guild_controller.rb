require 'SQL'
class GuildController < ApplicationController

  before_action :require_guild_admin, only: [:update_guild, :post_activity]
  before_action :set_variable


  def activity
    if params[:guildname].length > 17 || params[:guildname].include?("-")|| params[:guildname].include?("/")|| params[:guildname].include?("\\")|| params[:guildname].include?("'")|| params[:guildname].include?("\"")
      redirect_to root_path
    else
      shard = SQL.connect_shard
      @activities = shard[:_ZWEB_GUILD_ACTIVITY].where(:guildid => @guildid).all.reverse
      @master = shard[:_GuildMember].where(:guildid => @guildid, :memberclass => 0).all.last
    end
  end

  def post_activity
    @activity = ""
    if params[:update_text].to_s.blank?
      flash[:danger] = "you cannot post empty update !"
      redirect_to
    elsif params[:update_text].to_s.length > 300
      flash[:danger] = "too huge update post, please try to make it less than 300 characters"
      redirect_to
    else
      shard = SQL.connect_shard
      exec = shard.call_mssql_sproc(:_ZWEB_POST_GUILD_ACTIVITY, args: {:GuildName => params[:guildname], :body =>  params[:update_text]})
      if exec[:result] == 1
        redirect_to
      else
        flash[:danger] = "Failed to post, try again"
        redirect_to
      end
    end

  end

  def manage
    if @admin == -1
      redirect_to "/guilds/" + @guildname
    end

  end

  def update_guild
    @setting = ""
    shard = SQL.connect_shard
    exec = shard.call_mssql_sproc(:_ZWEB_UPDATE_GUILD, args: {:GuildName => params[:guildname], :Desc =>  params[:updated_description], :Pimage => params[:plink], :Cimage => params[:clink]})
    if exec[:result] == -1
      flash[:danger] = "an error occured during update, your update operation maybe canceled"
      redirect_to
    else
      flash[:success] = "setting updated successfully"
      redirect_to
    end
  end

  def members
    shard = SQL.connect_shard
    @roles = []
    @roles[0] = 'Soldier'
    @roles[32] = "Miliarity Engineer"
    @roles[2] = "Deputy commander"
    @members = shard[:_GuildMember].where(:guildid => @guildid, :memberclass => 10).all
    @master =  shard[:_GuildMember].where(:guildid => @guildid, :memberclass => 0).all.last

  end


  def require_guild_admin
    shard = SQL.connect_shard
    exec = shard.call_mssql_sproc(:_ZWEB_CHECK_AUTH, args: {:GuildName => params[:guildname], :UserName =>  current_user.username})
    @admin = exec[:result].to_i
    if @admin == -1
      flash[:danger] = "Authuntication error please try again "
      redirect_to
    end
  end


  def set_variable
    shard = SQL.connect_shard
    exec = shard.call_mssql_sproc(:_ZWEB_GET_GUILD_ID, args: {:GuildName => params[:guildname]})
    @guildid = exec[:id].to_i
    if @guildid == -1
      redirect_to root_path
    else
      exec = shard.call_mssql_sproc(:_ZWEB_CHECK_AUTH, args: {:GuildName => params[:guildname], :UserName =>  current_user.username})
      @admin = exec[:result].to_i
      exec = shard.call_mssql_sproc(:_ZWEB_GET_GUILD, args: {:GuildName => params[:guildname]})
      @guildname = params[:guildname]
      @description = exec[:description]
      @pimage = exec[:pimage]
      @info = shard[:_Guild].where(:id => @guildid).all.last
      if remote_file_exists?(@pimage)
        @profileimage = @pimage
      else
        @profileimage = '../../assets/guild/Default-profile.jpg'
      end

      @cimage = exec[:cimage]

      if remote_file_exists?(@cimage)
        @coverimage = @cimage
      else
        @coverimage = '../../assets/guild/Default-cover.jpg'
      end
    end

  end

  def remote_file_exists?(url)
    #
    # if uri?(url)
    #   url = URI.parse(url)
    # else
    #   return false
    # end
    #
    # Net::HTTP.start(url.host, url.port) do |http|
    #   return http.head(url.request_uri)['Content-Type'].start_with? 'image'
    # end
    uri = URI.parse(url)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

  def uri?(string)
    uri = URI.parse(string)
    %w( http https ).include?(uri.scheme)
  rescue URI::BadURIError
    false
  rescue URI::InvalidURIError
    false
  end

end