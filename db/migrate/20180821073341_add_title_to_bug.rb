class AddTitleToBug < ActiveRecord::Migration[5.2]
  def change
    add_column :bugs,:title,:string
  end
end
