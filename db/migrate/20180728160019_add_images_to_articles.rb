class AddImagesToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :timage , :string
    add_column :articles, :fimage , :string
  end
end
