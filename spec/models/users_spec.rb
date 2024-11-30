

require_relative '../spec_helper'
require_relative '../../app/models/user'

RSpec.describe User do
  before(:each) do
    @user = User.new
  end

  describe '#password=' do
    it 'hashes the password using BCrypt' do
      plain_text_password = 'secure_password'
      @user.password = plain_text_password
      expect(@user.password_digest).not_to eq(plain_text_password)
    end
  end

  describe '#valid_password?' do
    it 'returns true for correct password' do
      password = 'correct_password'
      @user.password = password
      expect(@user.valid_password?(password)).to be true
    end

    it 'returns false for incorrect password' do
      @user.password = 'correct_password'
      expect(@user.valid_password?('wrong_password')).to be false
    end
  end
end
