class AddFaqAttr < ActiveRecord::Migration[5.2]
  def change
    create_table :faqs do |t|
      t.text :question
      t.text :answer
      t.integer :user_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
