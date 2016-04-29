class DashboardRegisteredZohoJob <  ActiveJob::Base
  queue_as :default

  #TODO CHANGE LEAD TO PROFILE
  def perform(profile)
    l = RubyZoho::Crm::Lead.find_by_email(profile.email)
    if !l.nil?
      uri = "https://crm.zoho.com/crm/private/xml/Leads/updateRecords?"\
            "authtoken=43a02c5e40acfc842e2e8ed75424ecdf"\
            "&scope=crmapi"\
            "&id=#{l.first.leadid}"\
            "&xmlData=<Leads><row no='1'>"\
            "<FL val='Dashboard Been Registered?'>Yes</FL>"\
            "</row></Leads>"
      url = URI.parse(uri);
      Net::HTTP.post_form(url, {})
    else
      raise Exception.new("Zoho lead not accessible via CRM API")
    end
  end
end