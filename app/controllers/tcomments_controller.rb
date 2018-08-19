class TcommentsController < ApplicationController
  before_action :find_ticket
  before_action :find_comment , only: [:destroy, :edit , :update, :comment_owner,:comment_deleter]
  before_action :comment_owner , only: [:edit, :update]
  before_action :comment_deleter , only: [:destroy]
  before_action :require_not_closed , only: [:create,:destroy,:edit,:update]
  def create
    @tcomment = @ticket.tcomments.create(params[:tcomment].permit(:content))
    @tcomment.user_id = current_user.id
    @tcomment.save

    if @tcomment.save
      redirect_to ticket_path(@ticket)
    else
      render 'new'
    end

  end
  def destroy
    @tcomment.destroy
    redirect_to ticket_path(@ticket)
  end
  def edit

  end
  def update
    if @tcomment.update(params[:tcomment].permit(:content))
      redirect_to ticket_path(@ticket)
    else
      render 'edit'
    end
  end


  private
  def find_ticket
    @ticket = Ticket.find(params[:ticket_id])

  end
  def find_comment
    @tcomment = @ticket.tcomments.find(params[:id])
  end
  def comment_owner
    unless current_user.id == @tcomment.user_id
      flash[:danger]= "You cant do that!!!"
      redirect_to @ticket

    end
  end
  def comment_deleter
    unless (current_user.id == @tcomment.user_id || current_user.admin?)
      flash[:danger]= "You cant do that!!!"
      redirect_to @ticket

    end
  end
  def require_not_spam
    if current_user.spam?
      flash[:danger]="You are spam you can't add comments!!!"
      redirect_to root_path
    end
  end
  def require_not_closed
    if @ticket.status != true
      flash[:danger]="This ticket closed!!!"
      redirect_to root_path
    end
  end
  end
