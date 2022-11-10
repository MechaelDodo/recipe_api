class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.string :description_id, null: false
      t.string :image
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
