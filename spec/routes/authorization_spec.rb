

require 'rspec'
require 'rack/test'
require_relative '../spec_helper'
require_relative '../../app/routes/authorization'

RSpec.describe AuthorizationRouter do
  include Rack::Test::Methods

  def app
    AuthorizationRouter.new
  end

  describe 'POST /login' do
    context 'with valid credentials' do
      it 'returns a JWT token' do
        post '/login', { username: 'created_user', password: 'password123' }.to_json,
             { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(200)
        parsed_response = JSON.parse(last_response.body)
        expect(parsed_response['token']).not_to be_nil
      end
    end

    context 'with invalid credentials' do
      it 'returns an error for wrong password' do
        post '/login', { username: 'testuser', password: 'wrongpassword' }.to_json,
             { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(401)
        parsed_response = JSON.parse(last_response.body)
        expect(parsed_response['error']).to eq('Invalid username or password')
      end

      it 'returns an error for nonexistent username' do
        post '/login', { username: 'nonexistent', password: 'password123' }.to_json,
             { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(401)
        parsed_response = JSON.parse(last_response.body)
        expect(parsed_response['error']).to eq('Invalid username or password')
      end
    end
  end
end
