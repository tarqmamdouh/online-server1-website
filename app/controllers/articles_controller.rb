class ArticlesController < ApplicationController
  before_action :set_article , only: [:edit , :update , :show, :destroy]
 before_action :require_admin, only: [:destroy,:update,:edit,:new,:create]
  def index
    @articles = Article.order('updated_at DESC').paginate(page: params[:page], per_page: 5)
  end


  def new
    @article = Article.new
  end
  def edit

  end
  def create

    @article = Article.new(article_params)
    @article.user = current_user

    if @article.save
      flash[:notice] = "Article was successfully created"
      redirect_to article_path(@article)
    else
      render 'new'
    end
  end
    def update

      if @article.update(article_params)
        flash[:notice]= "Article was successfully updated"
        redirect_to article_path(@article)
      else
        render 'edit'
      end
    end

  def show
    @a = Category.find_by_name("Announcements")
    @announcements = @a.articles.all.last(3)
    @comments = Comment.where(article_id: @article)
  end

  def destroy
    @article.destroy
    flash[:danger]= "Article was successfully deleted"
    redirect_to articles_path
  end

  private
  def set_article
    @article = Article.find(params[:id])
  end

  def article_params

    params.require(:article).permit(:title, :description, :timage,:fimage, category_ids: [])

  end
  def require_admin
    if current_user.admin != true
      flash[:danger]="You can read articles only!!"
      redirect_to root_path
    end
  end
end