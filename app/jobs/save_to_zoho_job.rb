class SaveToZohoJob < ActiveJob::Base
  queue_as :default
 
  def perform(lead)
    zoho_lead = RubyZoho::Crm::Lead.new(
        first_name: lead.first_name,
        last_name: lead.last_name,
        email: lead.email,
        phone: lead.phone,
        street: lead.address,
        city: lead.city,
        state: lead.state,
        zip_code: lead.get_started.area_code,
        source: lead.source,
        ip_address: lead.ip,
        referrer: lead.referer,
        #can just be start_time - created_at
        time_on_site: lead.created_at - lead.start_time,
        campaign: lead.campaign,
        browser: lead.browser,
        interested_in_energy_plan: lead.get_started.energy_analysis,
        interested_in_solar: lead.get_started.solar,
        average_electric_bill: lead.get_started.average_electric_bill
    )
    zoho_lead.save
    lead.update_attributes(saved_to_zoho: true)
  end
end