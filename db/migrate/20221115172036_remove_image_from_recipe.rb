# frozen_string_literal: true

class RemoveImageFromRecipe < ActiveRecord::Migration[7.0]
  def change
    remove_column :recipes, :image, :string
  end
end
