require "SQL"
class WelcomeController < ApplicationController
  skip_before_action :authenticate_user! , only: [:index,:unconfirmed , :confirmed]
  before_action :require_admin , only: [:admin, :pins]
  def index
      @a = Category.find_by_name("Announcements")
      @announcements = @a.articles.all.last(6)

      @e= Category.find_by_name("Events")
      @events = @e.articles.all.last(6)

      @m=Category.find_by_name("Maintenance")
      @maintenance = @m.articles.all.last(6)

      @u= Category.find_by_name("Updates")
      @updates = @u.articles.all.last(6)


    @DB= SQL.connect_shard
    @DBB = SQL.connect_shardlog
    uniqevent = @DBB[:_LogEventUnique]
    @lastkill = uniqevent.select(:CharName16,:ObjectName,:EventTime).all.last(5)
   # @charid
   # @charname=
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
