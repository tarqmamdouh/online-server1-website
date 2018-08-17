class TimeToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets,:created_at,:datetime
  end
end
