class VhangePinsDefault < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :pins , :double , default:  0
  end
end
