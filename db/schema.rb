# frozen_string_literal: true

ActiveRecord::Schema[7.0].define(version: 20_221_111_112_053) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'ingredients', force: :cascade do |t|
    t.string 'title', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
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
