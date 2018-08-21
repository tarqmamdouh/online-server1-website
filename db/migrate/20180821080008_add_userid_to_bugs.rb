class AddUseridToBugs < ActiveRecord::Migration[5.2]
    def change
      add_column :bugs, :user_id, :integer
    end
  end
