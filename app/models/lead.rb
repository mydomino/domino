class Lead < ActiveRecord::Base
  geocoded_by :ip, :lookup => :telize
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city = geo.city
      obj.zip_code = geo.postal_code
      obj.state = geo.state
    end
  end
  after_create :schedule_geocode, :deliver_thank_you_email, :save_to_zoho
  validates :last_name, presence: true
  validates :email, presence: true
  default_scope { order('created_at DESC') }
  belongs_to :get_started

  def interested_in_solar
    return false if !get_started.present?
    return get_started.solar
  end

  def interested_in_energy_plan
    return false if !get_started.present?
    return get_started.energy_analysis
  end

  def monthly_electric_bill
    return false if !get_started.present?
    return get_started.average_electric_bill
  end

  def area_code
    return zip_code if !get_started.present?
    return get_started.area_code
  end


  private

  def save_to_zoho
    SaveToZohoJob.perform_later self
  end

  def schedule_geocode
    LeadGeocoderJob.perform_later self
  end

  def deliver_thank_you_email
    UserMailer.welcome_email(email).deliver_later
  end

end
