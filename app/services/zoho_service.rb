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
end