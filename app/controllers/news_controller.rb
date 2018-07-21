class NewsController < ApplicationController
  def new
@news = New.new
  end
  def create
   @news = New.new(news_params)
    @news.save
  end
  private
  def news_params
    params.require(:news).permit(:title, :description)
    redirect_to news_path(@news)
  end
end