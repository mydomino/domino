require 'rails_helper'
require 'helpers/zoho_mock'
require 'helpers/mandrill_mock'

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

  it 'cannot be saved without an email or phone number' do

    lead = FactoryGirl.build(:lead, email: "", phone: "")

    expect(lead.save).to be false

  end

  it 'saves itself to Zoho upon creation' do

    zoho_lead = spy('zoho_lead')
    allow(RubyZoho::Crm::Lead).to receive(:new).and_return(zoho_lead)

    lead = FactoryGirl.create(:lead)

    expect(zoho_lead).to have_received(:save)
  end

  it 'send an email to the correct address' do
    mandrill = spy('mandrill')
    #mandrill send function is monkeypatched
    allow(mandrill.messages).to receive(:send)
    allow(Mandrill::API).to receive(:new).and_return(mandrill)
    email = Faker::Internet.email
    
    lead = FactoryGirl.create(:lead, email: email)

    expect(mandrill.messages).to have_received(:send).with({"headers"=>{"Reply-To"=>"myconcierge@mydomino.com"},
     "track_clicks"=>true,
     "track_opens"=>true,
     "from_email"=>"amy@mydomino.com",
     "from_name"=>"Amy Gormin",
     "text"=>"Thank you for contacting Domino! Our fabulous energy savings concierge team will contact you soon!",
     "inline_css"=>nil,
     "track_opens"=>nil,
     "to"=>[{"email"=>email}],
     "html"=>'<p>Thank you for contacting Domino!</p><p>Our fabulous energy savings concierge team will contact you soon!</p><p>Warmly, The Domino Team</p>',
     "important"=>false,
     "auto_text"=>true,
     "subject"=>"Thanks from Domino",
     "merge"=>true,
     "signing_domain"=>"mydomino.com",
     "view_content_link"=>nil,
     "preserve_recipients"=>true})
  end

  it 'geocodes its ip upon creation'
end