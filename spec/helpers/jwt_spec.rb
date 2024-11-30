require 'rspec'
require 'jwt'
require 'rack/test'
require_relative '../spec_helper'
require_relative '../../app/helpers/jwt_helpers'
require_relative '../../app/models/user'

RSpec.describe JWTHelpers do
  include JWTHelpers

  let(:payload) { { data: 'test' } }

  describe '#encode_jwt' do
    it 'encodes a payload into a JWT' do
      token = encode_jwt(payload)
      expect(token).not_to be_nil
      expect { JWT.decode(token, SECRET_KEY, true, algorithm: 'HS256') }.not_to raise_error
    end
  end

  describe '#decode_jwt' do
    it 'decodes a valid JWT token' do
      token = encode_jwt(payload)
      decoded_payload = decode_jwt(token)
      expect(decoded_payload.to_json).to eq(payload.to_json)
    end
  end
end
