require 'rails_helper'

describe Contest, type: :model do
  it 'has a valid factory', focus: true do
    expect {FactoryGirl.create(:contest)} .not_to raise_exception
  end
end