class AddSpam < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :spam  , :boolean , default: false
  end
end
