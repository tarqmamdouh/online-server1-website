class BugsAttr < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.string :username,:string
      t.string :email
      t.string :name
      t.text :details
    end
  end
end

