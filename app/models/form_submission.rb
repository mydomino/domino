class FormSubmission
  include ActiveModel::Model

  attr_accessor :name, :email, :phone, :city, :state, :zipcode, :ip, :source
  validates :name, :email, presence: true

  def save
    return false if invalid?
    lead = RubyZoho::Crm::Lead.new(
        last_name: @name,
        email: @email,
        phone: @phone,
        city: @city,
        state: @state,
        zip_code: @zipcode,
        source: @source,
        ip_address: @ip
        # originating_screen: '',
        # timezone: ''
    )
    lead.save
  end

end
