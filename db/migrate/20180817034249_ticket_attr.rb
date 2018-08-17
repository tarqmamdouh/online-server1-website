class TicketAttr < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.string :subject
      t.text :content
    end
  end
end
