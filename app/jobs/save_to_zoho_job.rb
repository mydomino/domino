class SaveToZohoJob < ActiveJob::Base
  queue_as :default

  def perform(lead)
    zoho_lead = RubyZoho::Crm::Lead.new.tap do |zoho_lead|
      zoho_lead.first_name = lead.first_name
      #last_name is a required field in zoho
      zoho_lead.last_name = lead.last_name.empty? ? "Not given" : lead.last_name 
      zoho_lead.email = lead.email
      zoho_lead.phone = lead.phone
      zoho_lead.street = lead.address
      zoho_lead.city = lead.city
      zoho_lead.state = lead.state
      zoho_lead.lead_source = lead.source
      zoho_lead.ip_address = lead.ip
      zoho_lead.referrer = lead.referer
      zoho_lead.browser = lead.browser
      zoho_lead.interested_in_energy_plan = lead.interested_in_energy_plan
      zoho_lead.avg_electric_bill = lead.monthly_electric_bill
      zoho_lead.zip_code = lead.area_code
      zoho_lead.campaign = lead.campaign
    end
    zoho_lead.save
    lead.update_attributes(saved_to_zoho: true)
  end
end
