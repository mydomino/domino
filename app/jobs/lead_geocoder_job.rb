class LeadGeocoderJob < ActiveJob::Base
  def perform(lead)
    lead.geocode
    lead.reverse_geocode
  end
end