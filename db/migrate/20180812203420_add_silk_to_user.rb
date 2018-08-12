class AddSilkToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :silk , :integer , default:  0
  end
end
