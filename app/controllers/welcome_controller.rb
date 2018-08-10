require "SQL"
class WelcomeController < ApplicationController
  skip_before_action :authenticate_user! , only: [:index,:unconfirmed , :confirmed]
  before_action :require_admin , only: [:admin, :pins]
  def index
    @a = Category.find("4")
    @announcements = @a.articles.last

    @e= Category.find("3")
    @events = @e.articles.last

    @m=Category.find("2")
    @maintenance = @m.articles.last


    @u= Category.find("1")
    @updates = @u.articles.last

    @DB= SQL.connect_shard
    @DBB = SQL.connect_shardlog
    uniqevent = @DBB[:_LogEventUnique]
    @lastkill = uniqevent.select(:CharName16,:ObjectName,:EventTime).all.last(5)
   # @charid
    #    @charname=
      #  @uniquename= @lastkill[:ObjectName]
      #          @killtime=

  end
  def confirmed
  end

  def unconfirmed
  end


  def download

  end

  private
  def require_admin



    if current_user.admin != true
      redirect_to root_path
    end
  end
  protected

end
