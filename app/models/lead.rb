class Lead < ActiveRecord::Base
  geocoded_by :ip
  reverse_geocoded_by :latitude, :longitude, :city => :city
  after_create :queue_geocode, :deliver_thank_you_email, :save_to_zoho
  validates :last_name, presence: true
  #Commenting out the 'either phone or email logic'
  #validates :phone, presence: true, unless: Proc.new { |lead| lead.email.present? }
  validates :email, presence: true#, unless: Proc.new { |lead| lead.phone.present? }
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
