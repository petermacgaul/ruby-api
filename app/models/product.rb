# frozen_string_literal: true

require 'sequel'

# Product is a model class that represents a product in the database.
# It inherits from Sequel::Model to gain access to Sequel's ORM methods.
class Product < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence %i[name value]
  end
end
