class RemoveColumnsCreatedAtAndUpdatedAtInIngredient < ActiveRecord::Migration[7.0]
  def change
    remove_column :ingredients, :created_at
    remove_column :ingredients, :updated_at
  end
end
