class Lead < ActiveRecord::Base
  geocoded_by :ip
  reverse_geocoded_by :latitude, :longitude, :city => :city
  after_create :queue_geocode, :deliver_thank_you_email, :save_to_zoho
  validates :last_name, presence: true
  #Commenting out the 'either phone or email logic'
  #validates :phone, presence: true, unless: Proc.new { |lead| lead.email.present? }
  validates :email, presence: true#, unless: Proc.new { |lead| lead.phone.present? }

  def geocoded?
    address.present? || city.present? || state.present? || zip_code.present?
  end

  private

  def save_to_zoho
    return false if invalid?
    SaveToZohoJob.perform_later self
  end 

  def queue_geocode
    LeadGeocoderJob.perform_later self
  end

  def deliver_thank_you_email
    UserMailer.welcome_email(email).deliver_later
  end

end
