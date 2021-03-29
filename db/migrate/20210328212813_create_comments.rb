class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :article, null: false, index: true, foreign_key: true
      t.text :body

      t.timestamps
    end
  end
end
