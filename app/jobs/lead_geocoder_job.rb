class LeadGeocoderJob < ActiveJob::Base
  def perform(lead)
    lead.geocode
    lead.reverse_geocode
    lead.update_attributes(geocoded: true)
  end
end