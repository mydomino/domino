class UpdateZohoJob <  ActiveJob::Base
  queue_as :default

  #TODO CHANGE LEAD TO PROFILE
  def perform(lead)
    l = RubyZoho::Crm::Lead.find_by_email(lead.email)
    if !l.nil?
      partner_code = PartnerCode.find_by_code(lead.partner_code)
      RubyZoho::Crm::Lead.update(
        :id => l.first.leadid,
        :first_name => lead.first_name,
        :last_name => lead.last_name,
        :street => "#{lead.address_line_1} #{lead.address_line_2}",
        :city => lead.city,
        :state => lead.state,
        :zip_code => lead.zip_code,
        :phone => lead.phone,
        :email => lead.email,
        :avg_electric_bill => lead.avg_electrical_bill,
        :partner_code => lead.partner_code,
        :partner_code_name => partner_code ? partner_code.partner_name : nil,
        :onboard_complete => lead.onboard_complete ? "Yes" : "No"
      )

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
            "<FL val='Interests'>#{@interests.join(';')};</FL>"\
            "<FL val='Own or Rent?'>#{lead.housing}</FL>"\
            "<FL val='Preferred Contact Day(s)'>#{lead.availability.days_to_s}</FL>"\
            "<FL val='Preferred Contact Time'>#{lead.availability.times_to_s}</FL>"\
            "<FL val='Appointment Comments'>#{lead.comments}</FL>"\
            "</row></Leads>"
      url = URI.parse(uri);
      Net::HTTP.post_form(url, {})
    else
      raise Exception.new("Zoho lead not accessible via CRM API")
    end
  end
end