# frozen_string_literal: true

class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.integer :user_id, null: false
      t.integer :friend_id, null: false
      t.index ['user_id'], name: 'index_friendships_on_user_id'
      t.index ['friend_id'], name: 'index_friendships_on_friend_id'

      t.timestamps
    end
    add_foreign_key :friendships, :users, column: :user_id
    add_foreign_key :friendships, :users, column: :friend_id
  end
end
