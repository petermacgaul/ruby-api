# frozen_string_literal: true

require 'sinatra/base'
require_relative '../helpers/jwt_helpers'
require_relative '../models/user'

# AuthorizationRouter handles routes related to user authorization.
# It inherits from Sinatra::Base to gain access to Sinatra's DSL for defining routes.
class AuthorizationRouter < Sinatra::Base
  helpers JWTHelpers

  post '/login' do
    content_type :json
    params = JSON.parse(request.body.read)

    user = User.first(username: params['username'])

    if user&.valid_password?(params['password'])
      token = encode_jwt(user_id: user.id)
      { token: token }.to_json
    else
      halt 401, { error: 'Invalid username or password' }.to_json
    end
  end
end
