# frozen_string_literal: true

require 'sequel'
require 'bcrypt'

# User is a model class that represents a user in the database.
# It inherits from Sequel::Model to gain access to Sequel's ORM methods.
class User < Sequel::Model
  include BCrypt

  def password=(new_password)
    self.password_digest = Password.create(new_password)
  end

  def password
    Password.new(password_digest)
  end

  def valid_password?(password)
    self.password == password
  end
end
