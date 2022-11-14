class AddForeignKeiesToRecipeAndCart < ActiveRecord::Migration[7.0]
  def change
    remove_column :recipes, :user_id
    remove_column :carts, :user_id
    add_reference :recipes, :user, foreign_key: true
    add_reference :carts, :user, foreign_key: true, unique: true
  end
end
