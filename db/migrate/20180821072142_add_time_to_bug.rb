class AddTimeToBug < ActiveRecord::Migration[5.2]
    def change
      add_column :bugs,:created_at,:datetime
    end
  end
