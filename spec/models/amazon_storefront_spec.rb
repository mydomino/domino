require 'rails_helper'

describe AmazonStorefront, type: :model do
  
  let(:subject) { FactoryGirl.create(:amazon_storefront) } 
  let(:product) { FactoryGirl.create(:amazon_product) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'has some products' do
    expect { subject.amazon_products } .not_to raise_error
  end

  it 'can have a product added to it' do
    expect { subject.amazon_products << product } .not_to raise_error
    expect(subject.amazon_products).to include(product)
  end

  


end