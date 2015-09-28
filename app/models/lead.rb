class Lead < ActiveRecord::Base
  geocoded_by :ip, :lookup => :telize
  reverse_geocoded_by :latitude, :longitude do |obj,results|
  if geo = results.first
    obj.city = geo.city
    obj.zip_code = geo.postal_code
    obj.state = geo.state
  end
end
  after_create :queue_geocode, :deliver_thank_you_email, :save_to_zoho
  validates :last_name, presence: true
  validates :email, presence: true
  default_scope { order('created_at DESC') }

  private

  def save_to_zoho
    SaveToZohoJob.perform_later self
  end

  def queue_geocode
    LeadGeocoderJob.perform_later self
  end

  def deliver_thank_you_email
    UserMailer.welcome_email(email).deliver_later
  end

end
