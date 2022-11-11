# frozen_string_literal: true

# General Migration
class GeneralMigration < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :title, null: false

      t.timestamps
    end
    create_table :recipes do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :image
      t.integer :user_id, null: false

      t.timestamps
    end
    create_join_table :ingredients, :recipes
  end
end
