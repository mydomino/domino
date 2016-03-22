class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class Profile < ActiveRecord::Base

  belongs_to :user
  has_one :availability
  has_many :interests, dependent: :destroy
  has_many :offerings, through: :interests

  # validates :first_name, :last_name, :email, presence: true
  # validates :email, uniqueness: true, email: true

  # after_create :save_to_zoho
  # after_update :update_zoho

  accepts_nested_attributes_for :offerings, :availability

  

  def save_to_zoho
    SaveToZohoJob.perform_now self
  end

  def update_zoho
    begin
      UpdateZohoJob.perform_now self
      # UpdateZohoJob.perform_now self
    rescue => each
      puts "UNABLE TO UPDATE RECORD!!!!!!!!!!!!!!"
    end

    # UpdateZohoJob.perform_later self
  end
  handle_asynchronously :update_zoho, :run_at => Proc.new { 3.minutes.from_now }
end
