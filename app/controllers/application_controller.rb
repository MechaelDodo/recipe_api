# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::API
  SECRET = 'my$ecretK3y'

  # Authorization: Bearer <token>
  def encode_token(payload)
    JWT.encode(payload, SECRET, 'HS256')
  end

  def decode_token
    auth_header = request.headers['Authorization']
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, SECRET, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authorized_user
    decoded_token = decode_token
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def authorize
    render json: { message: 'You have to login.' }, status: :unauthorized unless authorized_user
  end
end
