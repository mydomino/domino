class Lead < ActiveRecord::Base
  after_save :save_to_zoho
  validates :first_name, :last_name, :email, presence: true

  private

  def save_to_zoho
    return false if invalid?
    lead = RubyZoho::Crm::Lead.new(
        last_name: @name,
        email: @email,
        phone: @phone,
        street: @address,
        city: @city,
        state: @state,
        zip_code: @zipcode,
        source: @source,
        ip_address: @ip,
        referrer: @referer,
        time_on_site: time_diff(@start_time),
        campaign: @campaign,
        browser: @browser
    )
    lead.save
  end

  def time_diff(start_time)
    return if !start_time
    seconds_diff = (Time.parse(start_time) - Time.now).to_i.abs

    hours = seconds_diff / 3600
    seconds_diff -= hours * 3600

    minutes = seconds_diff / 60
    seconds_diff -= minutes * 60

    seconds = seconds_diff

    "#{hours.to_s.rjust(2, '0')}:#{minutes.to_s.rjust(2, '0')}:#{seconds.to_s.rjust(2, '0')}"
  end

end
