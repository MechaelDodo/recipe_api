# frozen_string_literal: true

class CreateCartIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_ingredients do |t|
      t.belongs_to :cart
      t.belongs_to :ingredient
      t.timestamps
    end
  end
end
