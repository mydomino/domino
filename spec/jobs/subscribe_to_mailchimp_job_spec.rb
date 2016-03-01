require 'rails_helper'

describe SubscribeToMailchimpJob do

  def set_mailchimp_api_key
    ENV["MAILCHIMP_API_KEY"] = '1234567'
  end

  it "Calls the mailchimp api" do
    set_mailchimp_api_key
    mailchimp = spy("Mailchimp")
    allow(Mailchimp::API).to receive(:new).and_return(mailchimp)
    lead = double("Lead", email: Faker::Internet.email)

    SubscribeToMailchimpJob.perform_now(lead)

    expect(mailchimp).to have_received(:subscribe).with('0e3b74fe55', 
                                                        {"email" => lead.email})
  end

end
