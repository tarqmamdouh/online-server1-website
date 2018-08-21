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

      redirect_to '/news'

    else

      render 'new'

    end

  end
  def show

    @a = Category.find_by_name("Announcements")
    @announcements = @a.articles.all.last(3)

    @category = Category.find_by_name(params[:name])

    @category_articles = @category.articles.order('updated_at DESC').paginate(page: params[:page], per_page: 9)

  end

  def edit

    @category = Category.find(params[:id])

  end

  def update

    @category = Category.find(params[:id])

    if @category.update(category_params)

      flash[:success] = "Category name was successfully updated"

      redirect_to "/news/"+@category.name

    else

      render 'edit'

    end

  end
  private

  def category_params

    params.require(:category).permit(:name)

  end
  private
  def require_admin
    if current_user.admin != true
      flash[:danger]="You can view Categories only!!"
      redirect_to '/news'
    end
  end

end