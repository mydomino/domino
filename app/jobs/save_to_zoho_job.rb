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
        zip_code: lead.zip_code,
        source: lead.source,
        ip_address: lead.ip,
        referrer: lead.referer,
        #can just be start_time - created_at
        time_on_site: lead.created_at - lead.start_time,
        campaign: lead.campaign,
        browser: lead.browser
    )
    zoho_lead.save
  end
end