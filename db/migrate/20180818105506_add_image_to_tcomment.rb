class AddImageToTcomment < ActiveRecord::Migration[5.2]
  def up
    add_attachment :tcomments, :image
  end

  def down
    remove_attachment :tcomments, :image
  end
end