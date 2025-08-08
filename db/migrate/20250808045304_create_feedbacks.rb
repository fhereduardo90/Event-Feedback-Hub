class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.references :event, null: false, foreign_key: true
      t.string :user_name
      t.string :user_email
      t.text :feedback_text
      t.integer :rating

      t.timestamps
    end
  end
end
