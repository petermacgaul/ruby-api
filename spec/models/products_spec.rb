

require_relative '../spec_helper'
require_relative '../../app/models/product'

RSpec.describe Product do
  let(:valid_attributes) { { name: 'Test Product', value: 100 } }
  let(:invalid_attributes) { { name: '', value: nil } }

  describe 'validations' do
    it 'is valid with all attributes present' do
      product = Product.new(valid_attributes)
      expect(product.valid?).to be true
    end

    it 'is invalid without a name' do
      product = Product.new(valid_attributes.merge(name: ''))
      expect(product.valid?).to be false
      expect(product.errors[:name]).to include('is not present')
    end

    it 'is invalid without a value' do
      product = Product.new(valid_attributes.merge(value: nil))
      expect(product.valid?).to be false
      expect(product.errors[:value]).to include('is not present')
    end
  end
end
