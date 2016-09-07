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

  it "is not valid without a email address" do
    @profile.email= nil
    expect(@profile).to_not be_valid
  end

  it "is not valid without a phone number" do
    @profile.phone = nil
    expect(@profile).to_not be_valid
  end

  it "is not valid without a city" do
    @profile.city = nil
    expect(@profile).to_not be_valid
  end

  it "is not valid without a state" do
    @profile.state = nil
    expect(@profile).to_not be_valid
  end

  it "is not valid without a zip code" do
    @profile.zip_code = nil
    expect(@profile).to_not be_valid
  end

  it "is not valid without a housing status" do
    @profile.housing = nil
    expect(@profile).to_not be_valid
  end

end