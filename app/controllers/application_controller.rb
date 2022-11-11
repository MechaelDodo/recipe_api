# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  SECRET = 'my$ecretK3y'

  def encode_token(payload)
    JWT.encode payload, SECRET, 'HS256'
  end
end
