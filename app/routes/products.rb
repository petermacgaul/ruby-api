# frozen_string_literal: true

require 'sinatra/base'
require_relative '../helpers/jwt_helpers'
require_relative '../models/product'

# ProductsRouter handles routes related to product operations.
# It inherits from Sinatra::Base to gain access to Sinatra's DSL for defining routes.
class ProductsRouter < Sinatra::Base
  helpers JWTHelpers

  get '/products' do
    verify_jwt!

    products = Product.all

    content_type :json
    products.map(&:values).to_json
  end

  get '/products/:id' do
    verify_jwt!

    product = Product[params[:id].to_i]

    if product
      status = 200
      result = product.values.to_json
    else
      status = 404
      result = { error: 'Product not found' }.to_json
    end

    content_type :json
    status status
    result
  end

  post '/products' do
    verify_jwt!
    content_type :json

    Thread.new do
      sleep 5

      product_params = JSON.parse(request.body.read)

      product = Product.new(
        name: product_params['name'],
        value: product_params['value']
      )

      if product.valid? && product.save
        status 201
        product.values.to_json
        puts "Product created: #{product.name}"
      else
        puts product.errors.full_messages.join(', ')
      end
    end

    status 202
    body 'Product will be created in 5 seconds.'
  end
end
