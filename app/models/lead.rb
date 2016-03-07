class Lead < ActiveRecord::Base
  geocoded_by :ip, :lookup => :telize
  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city = geo.city
      obj.zip_code = geo.postal_code
      obj.state = geo.state
    end
  end
  after_create :schedule_geocode, :deliver_thank_you_email, :save_to_zoho, :upload_subscription_to_mailchimp
  validate :email_or_phone
  default_scope { order('created_at DESC') }
  belongs_to :get_started
  has_one :dashboard, foreign_key: :lead_email

  def interested_in_solar
    return false if !get_started.present?
    return get_started.solar
  end

  def interested_in_energy_plan
    return false if !get_started.present?
    return get_started.energy_analysis
  end

  def interests_as_string
    return '' if (!get_started.present? || !(get_started.solar || get_started.energy_analysis))
    interests = ' about '
    interests << 'solar energy' if get_started.solar
    interests << ' and ' if get_started.solar and get_started.energy_analysis
    interests << 'your energy plan' if get_started.energy_analysis
    interests << '.'
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

  def email_or_phone
    unless(email.present? || phone.present?)
      errors.add(:contact_method, "Please give us a way to contact you")
    end
  end

  def save_to_zoho
    SaveToZohoJob.perform_later self
  end

  def schedule_geocode
    LeadGeocoderJob.perform_later self
  end

  def deliver_thank_you_email
    UserMailer.welcome_email(email).deliver_later if Devise::email_regexp.match(email)
  end

  def upload_subscription_to_mailchimp
    if(subscribe_to_mailchimp)
      SubscribeToMailchimpJob.perform_later self
    end
  end

end
