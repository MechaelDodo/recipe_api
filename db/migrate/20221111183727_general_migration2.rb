# frozen_string_literal: true

class GeneralMigration2 < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    create_table :carts do |t|
      t.integer :user_id

      t.timestamps
    end
    create_table :cart_ingredients do |t|
      t.belongs_to :cart
      t.belongs_to :ingredient
      t.integer :user_id, null: false
    end
    remove_column :ingredients, :created_at
    remove_column :ingredients, :updated_at
  end
end
