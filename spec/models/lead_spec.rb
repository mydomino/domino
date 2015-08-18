require 'rails_helper'
require 'helpers/zoho_mock'

describe Lead, type: :model do
  
  let(:subject) { FactoryGirl.create(:lead) }

  it 'has a valid factory' do
    expect(subject).to be_valid
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

  it 'cannot be saved without an email or phone number' do
    lead = FactoryGirl.build(:lead, email: "", phone: "")

    expect(lead.save).to be false
  end

  it 'saves itself to Zoho upon creation' do
    expect { subject }.to enqueue_a(SaveToZohoJob)
  end

  it 'send an email to the correct address' do
    welcome_email = spy('welcome_email')
    allow(UserMailer).to receive(:welcome_email).and_return(welcome_email)
    allow(welcome_email).to receive(:deliver_later)
    email = Faker::Internet.email
    
    lead = FactoryGirl.create(:lead, email: email)

    expect(UserMailer).to have_received(:welcome_email).with(email)
    expect(welcome_email).to have_received(:deliver_later)
  end

  it 'geocodes its ip upon creation' do 
    expect { subject }.to enqueue_a(LeadGeocoderJob)
    expect(subject).to be_geocoded
  end
end