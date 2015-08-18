class Lead < ActiveRecord::Base
  after_create :deliver_thank_you_email, :save_to_zoho
  validates :last_name, presence: true
  #Commenting out the 'either phone or email logic'
  #validates :phone, presence: true, unless: Proc.new { |lead| lead.email.present? }
  validates :email, presence: true#, unless: Proc.new { |lead| lead.phone.present? }

  private

  def save_to_zoho
    return false if invalid?
    SaveToZohoJob.perform_later self
  end

  def geocode
    #todo
  end

  def deliver_thank_you_email
    UserMailer.welcome_email(email).deliver_later
  end

end
