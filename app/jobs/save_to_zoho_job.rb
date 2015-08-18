class SaveToZohoJob < ActiveJob::Base
  queue_as :default
 
  def perform(lead)
    zoho_lead = RubyZoho::Crm::Lead.new(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone,
        street: address,
        city: city,
        state: state,
        zip_code: zip_code,
        source: source,
        ip_address: ip,
        referrer: referer,
        #can just be start_time - created_at
        time_on_site: created_at - start_time,
        campaign: campaign,
        browser: browser
    )
    zoho_lead.save
  end
end