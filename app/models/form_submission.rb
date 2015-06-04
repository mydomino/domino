class FormSubmission
  include ActiveModel::Model

  def self.new(params)
    c = RubyZoho::Crm::Lead.new(
        last_name: params['name'],
        email: params['email'],
        phone: params['phone'],
        city: ''
    # source: '',
    # ip_address: '',
    # originating_screen: '',
    # timezone: ''
    )
    # c.save
  end

end
