require 'spec_helper'

describe LeadGeocoderJob do 
  it 'geocodes the lead!' do
    lead = FactoryGirl.create(:lead)

    LeadGeocoderJob.perform_now(lead)
    
    expect(lead).to be_geocoded
  end
end