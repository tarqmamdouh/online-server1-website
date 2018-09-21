require 'SQL'
class GuildController < ApplicationController

  before_action :require_guild_admin, only: [:update_guild]
  before_action :set_variable


  def activity

  end

  def post_activity

  end

  def manage

  end

  def update_guild

  end

  def members

  end


  def require_guild_admin
    shard = SQL.connect_shard
    exec = shard.call_mssql_sproc(:_ZWEB_CHECK_AUTH, args: {:GuildName => params[:guildname], :UserName =>  current_user.username})
    @admin = exec[:result].to_i
  end


  def set_variable
    shard = SQL.connect_shard
    exec = shard.call_mssql_sproc(:_ZWEB_GET_GUILD_ID, args: {:GuildName => params[:guildname]})
    @guildid = exec[:id].to_i
    if @guildid == -1
      redirect_to root_path
    end
  end

end