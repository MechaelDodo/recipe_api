# frozen_string_literal: true

class AddFirstRecipeToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_recipe, :boolean, default: false
  end
end
