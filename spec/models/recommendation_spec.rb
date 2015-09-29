require 'rails_helper'

describe Recommendation, type: :model do
  
  let(:subject) { FactoryGirl.create(:recommendation) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'sets itself to not done after creation' do 
    recommendation = FactoryGirl.build(:recommendation)

    expect(recommendation.done).to be_nil
    recommendation.save

    expect(recommendation.done).to be false
  end

  it 'assigns a concierge upon save' do
    recommendation = FactoryGirl.build(:recommendation)

    expect(recommendation).to receive(:assign_concierge)

    recommendation.save
  end

end