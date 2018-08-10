class ChangePinsToDouble < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :pins , :double
  end
end
