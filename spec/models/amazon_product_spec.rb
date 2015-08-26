require 'rails_helper'

describe AmazonProduct, type: :model do
  
  let(:subject) { FactoryGirl.create(:amazon_product) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'gets its name, URL, image and price from the Amazon API after create', focus: true do
    product = AmazonProduct.create(product_id: 'B009GDHYPQ')

    expect(product.name).not_to be_blank
  end

  it 'schedules a call to the Amazon API after create'


end