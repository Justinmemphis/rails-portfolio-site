class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text   :body, null: false
      t.datetime :published_at
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end