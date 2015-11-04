require 'rails_helper'

describe Contest, type: :model do
  it 'has a valid factory' do
    expect {FactoryGirl.create(:contest)} .not_to raise_exception
  end

  it 'is valid with a name, beginning, and end' do
    contest = FactoryGirl.build(:contest, name: 'A name', start_date: Date.today - 1, end_date: Date.today + 1)
    
    expect(contest.save).to be true
  end

  it 'is invalid with a missing name' do
    contest = FactoryGirl.build(:contest, name: '', start_date: Date.today - 1, end_date: Date.today + 1)
    
    expect(contest.save).to be false
  end

  it 'is invalid with a missing start date' do
    contest = FactoryGirl.build(:contest, name: 'A name', start_date: '', end_date: Date.today + 1)
    
    expect(contest.save).to be false
  end

  it 'is invalid with a missing end date' do
    contest = FactoryGirl.build(:contest, name: 'A name', start_date: Date.today - 1, end_date: '')

    expect(contest.save).to be false
  end

end