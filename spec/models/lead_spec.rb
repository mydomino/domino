require 'rails_helper'
require 'helpers/zoho_mock'

describe Lead, type: :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:lead)).to be_valid
  end
  it 'has a first name' do

    lead = FactoryGirl.create(:lead, first_name: "Josh")

    expect(lead.first_name).to eq("Josh")

  end

  it 'has a last name' do

    lead = FactoryGirl.create(:lead, last_name: "Morrow")

    expect(lead.last_name).to eq("Morrow")

  end

  it 'cannot be saved without a last name' do
    
    lead = FactoryGirl.build(:lead, last_name: "")

    expect(lead.save).to be false
  
  end

  it 'cannot be saved without an email' do

    lead = FactoryGirl.build(:lead, email: "")

    expect(lead.save).to be false

  end

  it 'saves itself to Zoho upon creation' do

    zoho_lead = spy('zoho_lead')
    allow(RubyZoho::Crm::Lead).to receive(:new).and_return(zoho_lead)

    lead = FactoryGirl.create(:lead)

    expect(zoho_lead).to have_received(:save)

  end
  it 'geocodes its ip upon creation'
end