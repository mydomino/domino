class UpdateZohoJob <  ActiveJob::Base
  queue_as :default

  #TODO CHANGE LEAD TO PROFILE
  def perform(lead)
    l = RubyZoho::Crm::Lead.find_by_email(lead.email)
    if !l.nil?

      #update interests using xml, for only text fields can be updated w/ rubyzoho
      @interests = []
      
      lead.offerings.each do |o|
        @interests << o.name 
      end


      #update lead interests using uri, for interests are combo boxes in zoho; comboboxes not settable via ruby zoho
      uri = "https://crm.zoho.com/crm/private/xml/Leads/updateRecords?"\
            "authtoken=43a02c5e40acfc842e2e8ed75424ecdf"\
            "&scope=crmapi"\
            "&id=#{l.first.leadid}"\
            "&xmlData=<Leads><row no='1'>"\
            "<FL val='First Name'>#{lead.first_name}</FL>"\
            "<FL val='Last Name'>#{lead.last_name}</FL>"\
            "<FL val='Email'>#{lead.email}</FL>"\
            "<FL val='Interests'>#{@interests.join(';')};</FL>"\
            "<FL val='Street'>#{lead.address_line_1} #{lead.address_line_2}</FL>"\
            "<FL val='City'>#{lead.city}</FL>"\
            "<FL val='State'>#{lead.state}</FL>"\
            "<FL val='Zip Code'>#{lead.zip_code}</FL>"\
            "<FL val='Phone'>#{lead.phone}</FL>"\
            "<FL val='Own or Rent?'>#{lead.housing}</FL>"\
            "<FL val='Avg Electric Bill'>#{lead.avg_electrical_bill}</FL>"\
            "<FL val='Partner Code'>#{lead.partner_code.code if lead.partner_code}</FL>"\
            "<FL val='Partner Code Name'>#{lead.partner_code.partner_name if lead.partner_code }</FL>"\
            "<FL val='Preferred Contact Day(s)'>#{lead.availability.days_to_s if lead.availability}</FL>"\
            "<FL val='Preferred Contact Time'>#{lead.availability.times_to_s if lead.availability}</FL>"\
            "<FL val='Appointment Comments'>#{lead.comments}</FL>"\
            "<FL val='Dashboard Registration'>http://mydomino.com/users/sign_up?email=#{lead.email}</FL>"\
            "<FL val='Onboard Complete'>#{lead.onboard_complete ? 'Yes' : 'No'}</FL>"\
            "</row></Leads>"
      url = URI.parse(uri);
      Net::HTTP.post_form(url, {})
    else
      raise Exception.new("Zoho lead not accessible via CRM API")
    end
  end
end