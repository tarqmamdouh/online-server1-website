class RemoveImageTcomment < ActiveRecord::Migration[5.2]
  def change
    remove_column :tcomments, :image
  end
end
