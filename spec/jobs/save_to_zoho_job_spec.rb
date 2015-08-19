require "rails_helper"

describe SaveToZohoJob do 
  let(:lead) { FactoryGirl.create(:lead) }

  it "calls save on the zoho lead" do
    zoho_lead = spy('zoho_lead')
    allow(RubyZoho::Crm::Lead).to receive(:new).and_return(zoho_lead)

    SaveToZohoJob.perform_now(lead)
    expect(zoho_lead).to have_received(:save)
    expect(lead).to be_saved_to_zoho
  end

end