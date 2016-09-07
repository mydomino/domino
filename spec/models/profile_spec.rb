require 'rails_helper'

RSpec.describe Profile, :type => :model do
  before(:each) do
    @profile = build(:profile)
  end

  it "is valid with valid attributes" do
    expect(@profile).to be_valid
  end

  it "is not valid without a first name" do
    @profile.first_name = nil
    expect(@profile).to_not be_valid
  end

  it "is not valid without a last name" do
    @profile.last_name = nil
    expect(@profile).to_not be_valid
  end

  it "is not valid without an email" do
    @profile.email = nil
    expect(@profile).to_not be_valid
  end


end