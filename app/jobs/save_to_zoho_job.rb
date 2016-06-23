class SaveToZohoJob < ActiveJob::Base
  queue_as :default

  def perform(lead)
  # Record insertion via rubyzoho gem
  #   zoho_lead = RubyZoho::Crm::Lead.new.tap do |zoho_lead|
  #     zoho_lead.first_name = lead.first_name
  #     #last_name is a required field in zoho
  #     zoho_lead.last_name = lead.last_name
  #     zoho_lead.email = lead.email
  #     zoho_lead.campaign = lead.campaign
  #     zoho_lead.ip_address = lead.ip
  #     zoho_lead.referrer = lead.referer
  #     zoho_lead.browser = lead.browser
  #     zoho_lead.onboard_complete = "No"
  #     zoho_lead.dashboard_been_registered? = "No"
  #   end
  #   zoho_lead.save
  # end
  uri = "https://crm.zoho.com/crm/private/xml/Leads/insertRecords?"\
        "newFormat=1"\
        "&authtoken=43a02c5e40acfc842e2e8ed75424ecdf"\
        "&wfTrigger=true"\
        "&scope=crmapi"\
        "&xmlData=<Leads><row no='1'>"\
        "<FL val='First Name'>#{lead.first_name}</FL>"\
        "<FL val='Last Name'>#{lead.last_name}</FL>"\
        "<FL val='Email'>#{lead.email}</FL>"\
        "<FL val='Campaign'>#{lead.campaign}</FL>"\
        "<FL val='Ip Address'>#{lead.ip}</FL>"\
        "<FL val='Browser'>#{lead.browser}</FL>"\
        "<FL val='Onboard Complete'>Yes</FL>"\
        "<FL val='Dashboard Been Registered?'>No</FL>"\
        "<FL val='Dashboard Registration URL'>mydomino.com/users/sign_up?email=#{lead.email}</FL>"\
        "</row></Leads>"

  encoded_url = URI.encode(uri)
  url = URI.parse(encoded_url)
  Net::HTTP.post_form(url, {})
  end
end