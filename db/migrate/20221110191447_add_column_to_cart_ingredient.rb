# frozen_string_literal: true

class AddColumnToCartIngredient < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_ingredients, :user_id, :integer, null: false
    remove_column :cart_ingredients, :created_at
    remove_column :cart_ingredients, :updated_at
  end
end
