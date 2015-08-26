require 'rails_helper'

describe AmazonProduct, type: :model do
  
  let(:subject) { FactoryGirl.create(:amazon_product) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'does some stuff'

end