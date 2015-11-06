class SaveToZohoJob < ActiveJob::Base
  queue_as :default

  def perform(lead)
    zoho_lead = RubyZoho::Crm::Lead.new.tap do |zoho_lead|
      zoho_lead.first_name = lead.first_name
      zoho_lead.last_name = lead.last_name || "Not given"
      zoho_lead.email = lead.email
      zoho_lead.phone = lead.phone
      zoho_lead.street = lead.address
      zoho_lead.city = lead.city
      zoho_lead.state = lead.state
      zoho_lead.lead_source = lead.source
      zoho_lead.ip_address = lead.ip
      zoho_lead.referrer = lead.referer
      zoho_lead.time_on_site = lead.created_at - lead.start_time
      zoho_lead.campaign = lead.campaign
      zoho_lead.browser = lead.browser
      zoho_lead.interested_in_solar = lead.interested_in_solar
      zoho_lead.interested_in_energy_plan = lead.interested_in_energy_plan
      zoho_lead.monthly_electric_bill = lead.monthly_electric_bill
      zoho_lead.zip_code = lead.area_code
    end
    zoho_lead.save
    lead.update_attributes(saved_to_zoho: true)
  end
end