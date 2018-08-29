class CreateTcomments < ActiveRecord::Migration[5.2]
  def change
    create_table :tcomments do |t|

      t.text :content
      t.references :ticket, foreign_key: true
      t.references :user, foreign_key: true

    end
  end
end
