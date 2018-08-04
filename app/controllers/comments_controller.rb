class CommentsController < ApplicationController
  before_action :find_article
  before_action :find_comment , only: [:destroy, :edit , :update, :comment_owner,:comment_deleter]
  before_action :comment_owner , only: [:edit, :update]
  before_action :comment_deleter , only: [:destroy]
  before_action :require_not_spam , only: [:create,:destroy,:edit,:update]
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
  def comment_owner
    unless current_user.id == @comment.user_id
      flash[:danger]= "You cant do that!!!"
      redirect_to @article

    end
  end
  def comment_deleter
    unless (current_user.id == @comment.user_id || current_user.admin?)
      flash[:danger]= "You cant do that!!!"
      redirect_to @article

    end
  end
  def require_not_spam
    if current_user.spam?
      flash[:danger]="You are spam you can't add comments!!!"
      redirect_to root_path
    end
    end
end
