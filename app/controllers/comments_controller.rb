class CommentsController < ApplicationController
  before_action :find_article
  before_action :find_comment , only: [:destroy, :edit , :update]
  def create
@comment = @article.comments.create(params[:comment].permit(:content))
    @comment.user_id = current_user.id
    @comment.save

    if @comment.save
      redirect_to article_path(@article)
    else
      render 'new'
    end

  end
  def destroy
@comment.destroy
    redirect_to article_path(@article)
  end
  def edit

  end
  def update
    if @comment.update(params[:comment].permit(:content))
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end


  private
  def find_article
    @article = Article.find(params[:article_id])

  end
  def find_comment
    @comment = @article.comments.find(params[:id])
  end
end
