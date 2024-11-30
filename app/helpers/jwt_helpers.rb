# frozen_string_literal: true

require 'jwt'

SECRET_KEY = ENV['JWT_SECRET_KEY'] || 'default_secret_key'

# JWTHelpers provides helper methods for encoding and decoding JWTs.
# It is used to encode and decode JWTs for user authentication.
module JWTHelpers
  def encode_jwt(payload)
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end

  def decode_jwt(token)
    JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256').first
  rescue JWT::ExpiredSignature
    halt 401, { error: 'Token has expired' }.to_json
  rescue JWT::DecodeError
    halt 401, { error: 'Invalid token' }.to_json
  end

  def verify_jwt!
    auth_header = request.env['HTTP_AUTHORIZATION']

    halt 401, { error: 'Authorization header is missing' }.to_json unless auth_header

    token = auth_header.split.last
    decoded_token = decode_jwt(token)

    if decoded_token
      @current_user = User.first(id: decoded_token['user_id'])
      halt 401, { error: 'User not found' }.to_json unless @current_user
    else
      halt 401, { error: 'Invalid token' }.to_json
    end
  end
end
