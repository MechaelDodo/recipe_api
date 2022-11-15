# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_one :cart
  has_many :recipes
  has_many :friendships, class_name: 'Friendship', foreign_key: :user_id
  has_many :friendships, class_name: 'Friendship', foreign_key: :friend_id
end
