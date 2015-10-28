class SaveToZohoJob < ActiveJob::Base
  queue_as :default

  def perform(lead)
    zoho_lead = RubyZoho::Crm::Lead.new.tap do |zoho_lead|
      zoho_lead.first_name = lead.first_name
      zoho_lead.last_name = lead.last_name
      zoho_lead.email = lead.email
      zoho_lead.phone = lead.phone
      zoho_lead.street = lead.address
      zoho_lead.city = lead.city
      zoho_lead.state = lead.state
      zoho_lead.source = lead.source
      zoho_lead.ip_address = lead.ip
      zoho_lead.referrer = lead.referer
      zoho_lead.time_on_site = lead.created_at - lead.start_time
      zoho_lead.campaign = lead.campaign
      zoho_lead.browser = lead.browser
      if(lead.get_started.present?)
        zoho_lead.interested_in_solar = lead.get_started.solar
        zoho_lead.interested_in_energy_plan = lead.get_started.energy_analysis
        zoho_lead.average_electric_bill = lead.get_started.average_electric_bill
        zoho_lead.zip_code = lead.get_started.area_code
      end
    end
    zoho_lead.save
    lead.update_attributes(saved_to_zoho: true)
  end
end