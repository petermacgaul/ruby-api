# frozen_string_literal: true

require 'sinatra/base'
require_relative '../models/user'

# UsersRouter handles routes related to user operations.
# It inherits from Sinatra::Base to gain access to Sinatra's DSL for defining routes.
class UsersRouter < Sinatra::Base
  post '/users' do
    content_type :json

    user_params = JSON.parse(request.body.read)

    if user_params['username'].nil? || user_params['password'].nil?
      status 400
      { error: 'Username and password are required' }.to_json
      return
    end

    user = User.new(username: user_params['username'])
    user.password = user_params['password']

    if user.save
      status 201
      { message: 'User created successfully', user_id: user.id }.to_json
    else
      status 400
      { error: user.errors.full_messages.join(', ') }.to_json
    end
  end
end
