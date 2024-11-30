

require 'rspec'
require 'rack/test'
require_relative '../../app/routes/users'

RSpec.describe UsersRouter do
  include Rack::Test::Methods

  def app
    UsersRouter.new
  end

  let(:valid_user_params) { { username: 'testuser', password: 'password123' }.to_json }
  let(:invalid_user_params) { { username: '' }.to_json }

  describe 'POST /users' do
    context 'with valid params' do
      it 'creates a new user' do
        previous_count = User.count
        post '/users', valid_user_params, { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(201)
        parsed_response = JSON.parse(last_response.body)
        expect(parsed_response['message']).to eq('User created successfully')
        expect(parsed_response['user_id']).not_to be_nil
        expect(User.count).to eq(previous_count + 1)
      end
    end

    context 'with missing username or password' do
      it 'returns a 400 status with validation error messages' do
        post '/users', invalid_user_params, { 'CONTENT_TYPE' => 'application/json' }

        expect(last_response.status).to eq(400)
      end
    end
  end
end
