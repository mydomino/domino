class SaveToZohoJob < ActiveJob::Base
  queue_as :default

  def perform(lead)
    uri = "https://crm.zoho.com/crm/private/xml/Leads/insertRecords?"\
          "newFormat=1"\
          "&authtoken=43a02c5e40acfc842e2e8ed75424ecdf"\
          "&scope=crmapi"\
          "&wfTrigger=true"\
          "&xmlData=<Leads><row no='1'>"\
          "<FL val='First Name'>#{lead.first_name}</FL>"\
          "<FL val='Last Name'>#{lead.last_name}</FL>"\
          "<FL val='Email'>#{lead.email}</FL>"\
          "<FL val='Campaign'>#{lead.campaign}</FL>"\
          "<FL val='Ip Address'>#{lead.ip}</FL>"\
          "<FL val='Browser'>#{lead.browser}</FL>"\
          "<FL val='Onboard Complete'>Yes</FL>"\
          "<FL val='Dashboard Been Registered?'>No</FL>"\
          "<FL val='Dashboard Registration URL'>http://mydomino.com/users/sign_up?email=#{lead.email}</FL>"\
          "</row></Leads>"
    encoded_url = URI.encode(uri)
    url = URI.parse(encoded_url)
    Net::HTTP.post_form(url, {})
  end
end
