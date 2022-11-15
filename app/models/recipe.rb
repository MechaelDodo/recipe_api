# frozen_string_literal: true

class Recipe < ApplicationRecord
  include Rails.application.routes.url_helpers

  has_one_attached :image

  has_and_belongs_to_many :ingredients
  belongs_to :user

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
end
