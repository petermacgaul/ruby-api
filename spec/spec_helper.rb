# frozen_string_literal: true

require 'rspec'
require_relative '../app/db'

RSpec.configure do |config|
  config.before(:suite) do
    DB[:users].truncate(cascade: true, restart: true)
    DB[:products].truncate(cascade: true, restart: true)

    DB[:users].insert(
      username: 'created_user',
      password_digest: BCrypt::Password.create('password123')
    )

    DB[:products].insert(name: 'Product A', value: 100)
  end

  config.around do |example|
    DB.transaction(rollback: :always, savepoint: true, auto_savepoint: true) do
      example.run
    end
  end

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
