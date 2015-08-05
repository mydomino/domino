class Lead < ActiveRecord::Base
  after_save :save_to_zoho
  validates :last_name, presence: true
  #Commenting out the 'either phone or email logic'
  validates :phone, presence: true#, unless: Proc.new { |lead| lead.email.present? }
  validates :email, presence: true#, unless: Proc.new { |lead| lead.phone.present? }

  private

  def save_to_zoho
    return false if invalid?
    return true if saved_to_zoho
    zoho_lead = RubyZoho::Crm::Lead.new(
        first_name: first_name,
        last_name: last_name,
        email: email,
        phone: phone,
        street: address,
        city: city,
        state: state,
        zip_code: zip_code,
        source: source,
        ip_address: ip,
        referrer: referer,
        #can just be start_time - created_at
        time_on_site: created_at - start_time,
        campaign: campaign,
        browser: browser
    )
    zoho_lead.save
    self.update_attribute(:saved_to_zoho, true)
  end

  def geocode
    #todo
  end

end
