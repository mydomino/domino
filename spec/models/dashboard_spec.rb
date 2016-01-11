require 'rails_helper'

describe Dashboard, type: :model do
  
  let(:subject) { FactoryGirl.create(:dashboard) } 
  let(:product) { FactoryGirl.create(:product, id: 2000) }
  let(:task) { FactoryGirl.create(:task, id: 2000) }

  it 'has a valid factory' do
    expect(subject).to be_valid
  end

  it 'has some recommendations' do
    expect { subject.recommendations } .not_to raise_error
  end

  it 'requires an email' do
    dashboard = FactoryGirl.build(:dashboard, lead_email: '')

    expect(dashboard.save).to be false
  end

  it 'can have two different types of recommendations with the same ID added' do
    expect(product.id).to eq(task.id)

    subject.recommendations.build(recommendable: product).save

    expect(subject.recommendations.build(recommendable: task).save).to be(true)
  end

  it 'cannot have two recommendations with the same ID and same type added' do
    subject.recommendations.build(recommendable: product).save

    expect(subject.recommendations.build(recommendable: product).save).to be(false)
  end

  it 'offers a slug candidate that is not taken by adding a number to the name' do
    dashboard = FactoryGirl.create(:dashboard, lead_name: 'Tom Waits')
    
    expect(dashboard.slug).to eq('tom-waits')

    for i in 1..15 do
      dashboard = FactoryGirl.create(:dashboard, lead_name: 'Tom Waits')
      expect(dashboard.slug).to eq("tom-waits-#{i}")
    end
  end

end