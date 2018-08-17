class AddTimeStampsToTcomments < ActiveRecord::Migration[5.2]
  def change
    add_column :tcomments,:created_at,:datetime
    add_column :tcomments,:updated_at,:datetime
  end
end
