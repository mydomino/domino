class SaveToZohoJob < ActiveJob::Base
  queue_as :default

  def perform(lead)
    #save interests using xml, for only text fields can be updated w/ rubyzoho
    @interests = []
    
    lead.offerings.each do |o|
      @interests << o.name 
    end
    uri = "https://crm.zoho.com/crm/private/xml/Leads/insertRecords?"\
          "newFormat=1"\
          "&authtoken=43a02c5e40acfc842e2e8ed75424ecdf"\
          "&wfTrigger=true"\
          "&scope=crmapi"\
          "&xmlData=<Leads><row no='1'>"\
          "<FL val='First Name'>#{lead.first_name}</FL>"\
          "<FL val='Last Name'>#{lead.last_name}</FL>"\
          "<FL val='Email'><![CDATA[#{CGI.escape(lead.email)}]]></FL>"\
          "<FL val='Campaign'>#{lead.campaign}</FL>"\
          "<FL val='Browser'>#{lead.browser}</FL>"\
          "<FL val='Interests'>#{@interests.join(';')};</FL>"\
          "<FL val='Street'><![CDATA[#{CGI.escape(lead.address_line_1) if !lead.address_line_1.nil?}]]></FL>"\
          "<FL val='City'>#{lead.city}</FL>"\
          "<FL val='State'>#{lead.state}</FL>"\
          "<FL val='Zip Code'>#{lead.zip_code}</FL>"\
          "<FL val='Phone'>#{lead.phone}</FL>"\
          "<FL val='Own or Rent?'>#{lead.housing}</FL>"\
          "<FL val='Avg Electric Bill'>#{lead.avg_electrical_bill}</FL>"\
          "<FL val='Onboard Complete'>Yes</FL>"\
          "<FL val='Dashboard Been Registered?'>No</FL>"\
          "<FL val='Dashboard Registration URL'>mydomino.com/users/sign_up?email=#{CGI.escape(CGI.escape(lead.email))}</FL>"\
          "<FL val='Partner Code'>#{lead.partner_code.code if lead.partner_code}</FL>"\
          "<FL val='Partner Code Name'>#{lead.partner_code.partner_name if lead.partner_code }</FL>"\
          "</row></Leads>"

    encoded_uri = URI(uri)
    puts encoded_uri
    res = Net::HTTP.post_form(encoded_uri, {})
  end
end