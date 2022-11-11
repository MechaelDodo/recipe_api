# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_221_111_112_053) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'cart_ingredients', force: :cascade do |t|
    t.bigint 'cart_id'
    t.bigint 'ingredient_id'
    t.integer 'user_id', null: false
    t.index ['cart_id'], name: 'index_cart_ingredients_on_cart_id'
    t.index ['ingredient_id'], name: 'index_cart_ingredients_on_ingredient_id'
  end

  create_table 'carts', force: :cascade do |t|
    t.integer 'user_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'ingredients', force: :cascade do |t|
    t.string 'title', null: false
  end

  create_table 'ingredients_recipes', id: false, force: :cascade do |t|
    t.bigint 'ingredient_id', null: false
    t.bigint 'recipe_id', null: false
  end

  create_table 'recipes', force: :cascade do |t|
    t.string 'title', null: false
    t.text 'description', null: false
    t.string 'image'
    t.integer 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'username'
    t.string 'email'
    t.string 'password_digest'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
