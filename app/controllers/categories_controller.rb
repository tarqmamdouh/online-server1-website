class CategoriesController < ApplicationController

  before_action :require_admin , except: [:index,:show]

  def index

    @categories = Category.paginate(page: params[:page], per_page: 5)
  end

  def new

    @category = Category.new

  end

  def create

    @category = Category.new(category_params)

    if @category.save

      flash[:success] = "Category was created successfully"

      redirect_to categories_path

    else

      render 'new'

    end

  end

  def show

  end

  private

  def category_params

    params.require(:category).permit(:name)

  end
  private
  def require_admin
    if current_user.admin != true
      flash[:danger]="You can view Categories only!!"
      redirect_to categories_path 
    end
  end

end