class SaveToZohoJob < ActiveJob::Base
  queue_as :default

  def perform(lead)
    zoho_lead = RubyZoho::Crm::Lead.new.tap do |zoho_lead|
      zoho_lead.first_name = lead.first_name
      #last_name is a required field in zoho
      zoho_lead.last_name = lead.last_name
      zoho_lead.email = lead.email
      zoho_lead.campaign = lead.campaign
      zoho_lead.ip_address = lead.ip
      zoho_lead.referrer = lead.referer
      zoho_lead.browser = lead.browser
      zoho_lead.onboard_complete = "No"
    end
    zoho_lead.save
  end
end
