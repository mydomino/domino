class Lead < ActiveRecord::Base
  after_create :deliver_thank_you_email, :save_to_zoho
  validates :last_name, presence: true
  #Commenting out the 'either phone or email logic'
  #validates :phone, presence: true, unless: Proc.new { |lead| lead.email.present? }
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

  def deliver_thank_you_email
    mandrill = Mandrill::API.new(ENV["MANDRILL_API_KEY"])
    message = {"headers"=>{"Reply-To"=>"myconcierge@mydomino.com"},
     "track_clicks"=>true,
     "track_opens"=>true,
     "from_email"=>"amy@mydomino.com",
     "from_name"=>"Amy Gormin",
     "text"=>"Thank you for contacting Domino! Our fabulous energy savings concierge team will contact you soon!",
     "inline_css"=>nil,
     "track_opens"=>nil,
     "to"=>[{"email"=>email}],
     "html"=>'<p>Thank you for contacting Domino!</p><p>Our fabulous energy savings concierge team will contact you soon!</p><p>Warmly, The Domino Team</p>',
     "important"=>false,
     "auto_text"=>true,
     "subject"=>"Thanks from Domino",
     "merge"=>true,
     "signing_domain"=>"mydomino.com",
     "view_content_link"=>nil,
     "preserve_recipients"=>true}
    mandrill.messages.send message
  end

end
