class UpdateZohoJob <  ActiveJob::Base
  queue_as :default

  #TODO CHANGE LEAD TO PROFILE
  def perform(lead)
    # begin
      l = RubyZoho::Crm::Lead.find_by_email(lead.email)
      # byebug
      RubyZoho::Crm::Lead.update(
        :id => l.first.leadid,
        :first_name => lead.first_name,
        :last_name => lead.last_name,
        :street => "#{lead.address_line_1}, #{lead.address_line_2}",
        :city => lead.city,
        :state => lead.state,
        :zip_code => lead.zip_code,
        :phone => lead.phone,
        :email => lead.email,
        :test_onboard_complete => lead.onboard_complete
      )

      #update interests using xml, for only text fields can be updated w/ rubyzoho
      @interests = []
      
      lead.offerings.each do |o|
        @interests << o.name 
      end

      #update lead interests using uri, for interests are combo boxes in zoho; comboboxes not settable via ruby zoho
      uri = "https://crm.zoho.com/crm/private/xml/Leads/updateRecords?authtoken=43a02c5e40acfc842e2e8ed75424ecdf&scope=crmapi&id=#{l.first.leadid}&xmlData=<Leads><row no='1'><FL val='test_interests'>#{@interests.join(';')};</FL></row></Leads>"
      url = URI.parse(uri);
      Net::HTTP.post_form(url, {})
      #set availability
      uri = "https://crm.zoho.com/crm/private/xml/Leads/updateRecords?authtoken=43a02c5e40acfc842e2e8ed75424ecdf&scope=crmapi&id=#{l.first.leadid}&xmlData=<Leads><row no='1'><FL val='Preferred Contact Day(s)'>#{lead.availability.days_to_s}</FL></row></Leads>"
      url = URI.parse(uri);
      Net::HTTP.post_form(url, {})
      #set availability time
      uri = "https://crm.zoho.com/crm/private/xml/Leads/updateRecords?authtoken=43a02c5e40acfc842e2e8ed75424ecdf&scope=crmapi&id=#{l.first.leadid}&xmlData=<Leads><row no='1'><FL val='Preferred Contact Time'>#{lead.availability.times_to_s}</FL></row></Leads>"
      url = URI.parse(uri);
      Net::HTTP.post_form(url, {})
      
    # rescue => e
    # end
    # zoho_lead = RubyZoho::Crm::Lead.find_by_email(lead.email) do |zoho_lead|
    #   zoho_lead.first_name = lead.first_name
    #   #last_name is a required field in zoho
    #   zoho_lead.last_name = lead.last_name.empty? ? "Not given" : lead.last_name 
    #   # zoho_lead.email = lead.email
    #   zoho_lead.phone = lead.phone
    #   zoho_lead.street = lead.address
    #   zoho_lead.city = lead.city
    #   # zoho_lead.state = lead.state
    #   # zoho_lead.lead_source = lead.source
    #   # zoho_lead.ip_address = lead.ip
    #   # zoho_lead.referrer = lead.referer
    #   # zoho_lead.time_on_site = lead.created_at - lead.start_time
    #   # zoho_lead.browser = lead.browser
    #   # zoho_lead.interested_in_solar = lead.interested_in_solar
    #   # zoho_lead.interested_in_energy_plan = lead.interested_in_energy_plan
    #   # zoho_lead.monthly_electric_bill = lead.monthly_electric_bill
    #   # zoho_lead.zip_code = lead.area_code
    #   # zoho_lead.campaign = lead.campaign
    # end
    # zoho_lead.save
    # lead.update_attributes(saved_to_zoho: true)
  end

end