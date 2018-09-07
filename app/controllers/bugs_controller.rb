class BugsController < ApplicationController
  before_action :set_bug , only: [:show]
  before_action :require_admin , only: [:show , :index]
  def index
    @bugs = Bug.order('created_at DESC').paginate(page: params[:page], per_page: 5)
  end


  def new
    @bug = Bug.new
  end
  def create

    @bug = Bug.new(bug_params)
    @bug.user = current_user

    if @bug.save
      render "success"
    else
      render 'new'
    end
  end

  def show
  end

  private
  def set_bug
    @bug = Bug.find(params[:id])
  end

  def bug_params

    params.require(:bug).permit(:name, :username,:email,:title ,:details ,:image)

  end
  def require_admin
    if current_user.admin? != true && current_user.support? != true
      redirect_to root_path
    end
  end
end