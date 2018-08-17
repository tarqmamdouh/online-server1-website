class AddAttrToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets , :status , :string
    add_column :tickets , :uniqid , :string
  end
end
