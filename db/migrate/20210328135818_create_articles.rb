class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.references :user, null: false ,index: true, foreign_key: true
      t.text :tags
      
      t.timestamps
    end
  end
end
