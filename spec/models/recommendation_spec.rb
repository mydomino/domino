require 'rails_helper'

describe Recommendation, type: :model do
  
  let(:subject) { FactoryGirl.create(:recommendation) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'does some stuff'

end