class EditStatusToBool < ActiveRecord::Migration[5.2]
  def change
    change_column :tickets , :status , :boolean , default:  true
  end
end
