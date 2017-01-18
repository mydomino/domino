# ZohoService
# This service is used to faciliate application communication with zoho

#https://crm.zoho.com/crm/private/xml/LeadsgetRecords?authtoken=4659beeabc65d330ffdfd3c1d029da31&scope=crmapi&newFormat=2
# 20 record default
# hwoodbury70@gmail.com
class ZohoService
  ZOHO_CRM_API_BASE_URL = "https://crm.zoho.com/crm/private/xml/Leads"
  ZOHO_GET_RECORDS_URL =  ZOHO_CRM_API_BASE_URL + "getRecords?" \
                          "authtoken=#{ENV['ZOHO_AUTH_TOKEN']}" \
                          "&scope=crmapi" \
                          "&newFormat=2"

  def initialize
  end

  def get_lead_by_email(email)
    RubyZoho::Crm::Lead.find_by_email(email)
  end

  # BEGIN save to zoho logic
  # Note:  This job uses delayed job to run the task in the background.
  #   In order to do so, we have to create a singleton version of the class 
  #   and mark the asynchronous methods with handle_asynchronously :your_async_method
  #   Reference: http://nlopez.io/using-delayed_job-with-class-methods/
  class << self
    def to_zoho(profile)

      # First check if record is present in zoho
      l = RubyZoho::Crm::Lead.find_by_email(profile.email)

      # If record is not already present, create one
      if !l
        l = RubyZoho::Crm::Lead.new(
          :first_name => profile.first_name,
          :last_name => profile.last_name,
          :email => profile.email
        )

        l.save
      end
    end
    handle_asynchronously :to_zoho
  end

  def self.save_to_zoho(profile)
    ZohoService.to_zoho(profile)
  end
  # END save to zoho logic
end