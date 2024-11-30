

require 'rspec'
require 'rack/test'
require_relative '../../app/helpers/jwt_helpers'
require_relative '../../app/routes/products'
require_relative '../../app/models/user'

RSpec.describe ProductsRouter do
  include Rack::Test::Methods
  include JWTHelpers

  def app
    ProductsRouter.new
  end

  let(:jwt_token) { encode_jwt(user_id: User.first.id) }

  def jwt_header
    { 'HTTP_AUTHORIZATION' => "Bearer #{jwt_token}", 'CONTENT_TYPE' => 'application/json' }
  end

  describe 'GET /products' do
    it 'returns a list of products' do
      get '/products', {}, jwt_header
      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      products = JSON.parse(last_response.body)
      expect(products.size).to eq(Product.count)
    end

    it 'requires JWT authentication' do
      get '/products'
      expect(last_response.status).to eq 401
    end
  end

  describe 'GET /products/:id' do
    it 'returns a product by ID' do
      product = Product.first
      get "/products/#{product.id}", {}, jwt_header

      expect(last_response.status).to eq 200
      expect(last_response.content_type).to eq 'application/json'
      product_data = JSON.parse(last_response.body)
      expect(product_data['name']).to eq('Product A')
    end

    it 'returns 404 for a non-existent product' do
      get '/products/999', {}, jwt_header
      expect(last_response.status).to eq 404
    end
  end

  describe 'POST /products' do
    it 'creates a new product' do
      product_params = { name: 'New Product', value: 300 }.to_json

      # Mock
      expect(Thread).to receive(:new).and_yield
      post '/products', product_params, jwt_header

      expect(last_response.status).to eq 202
      expect(last_response.body).to eq 'Product will be created in 5 seconds.'

      expect(Product.first(name: 'New Product')).not_to be_nil
      expect(Product.first(name: 'New Product').value).to eq 300
    end
  end
end
