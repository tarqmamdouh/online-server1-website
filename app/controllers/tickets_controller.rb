class TicketsController < ApplicationController
  before_action :set_ticket , only: [:show]
  before_action :require_admin , only: [:close_ticket]
  def index
    @tickets = Ticket.order('created_at DESC').paginate(page: params[:page], per_page: 5)
  end


  def new
    @ticket = Ticket.new
  end
  def create

    @ticket = Ticket.new(article_params)
    @ticket.user = current_user

    if @ticket.save
      flash[:notice] = "Ticket was successfully submitted"
      redirect_to ticket_path(@ticket)
    else
      render 'new'
    end
  end

  def show
    @tcomments = Tcomment.where(ticket_id: @ticket)
  end
  def close_ticket
    @ticket = Ticket.find_by(params[:id])
    if @ticket.status?
      @ticket.update(:status => false)
      flash[:notice] = "You closed this ticket!"
    end
    redirect_to ticket_path
  end
  private
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def article_params

    params.require(:ticket).permit(:subject, :content)

  end
  def require_admin
    if current_user.admin || current_user.support != true
      redirect_to root_path
    end
  end
end