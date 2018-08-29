class FaqController < ApplicationController
  before_action :set_faq , only: [:edit , :update,:destroy]
  before_action :require_admin, only: [:update,:edit,:new,:create,:destroy]
  def index
    @faqs = Faq.order('updated_at DESC').paginate(page: params[:page], per_page: 5)
  end


  def new
    @faq = Faq.new
  end
  def edit

  end
  def create

    @faq = Faq.new(faq_params)
    @faq.user = current_user

    if @faq.save
      flash[:notice] = "your question was successfully posted"
      redirect_to faq_index_path
    else
      render 'new'
    end
  end
  def update

    if @faq.update(faq_params)
      flash[:notice]= "question was successfully updated"
      redirect_to faq_index_path
    else
      render 'edit'
    end
  end
  def destroy
    @faq.destroy
    flash[:danger]= "question was successfully deleted"
    redirect_to faq_index_path
  end




  private
  def set_faq
    @faq = Faq.find(params[:id])
  end

  def faq_params

    params.require(:faq).permit(:question, :answer)

  end
  def require_admin
    if current_user.admin != true
      flash[:danger]="You can read FAQ only!!"
      redirect_to root_path
    end
  end
end