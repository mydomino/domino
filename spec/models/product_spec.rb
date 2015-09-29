require 'rails_helper'

describe Product, type: :model do
  
  let(:subject) { FactoryGirl.create(:product) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'gets its name, URL, image and price from the Amazon API after create' do
    product = Product.create(url: 'http://www.amazon.com/Nest-Learning-Thermostat-2nd-Generation/dp/B009GDHYPQ')

    expect(product.name).not_to be_blank
  end

  it 'correctly extracts a URL if it is not given an ID' do
    product = Product.new(url: 'http://www.amazon.com/Nest-Learning-Thermostat-2nd-Generation/dp/B009GDHYPQ')

    expect(product.product_id).to be_nil
    product.save
    expect(product.product_id).to eq('B009GDHYPQ')
  end

end