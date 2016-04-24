class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class Profile < ActiveRecord::Base

  belongs_to :user
  has_one :availability, dependent: :destroy
  has_many :interests, dependent: :destroy
  has_many :offerings, through: :interests
  accepts_nested_attributes_for :offerings, :availability
  
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true, email: true

  after_create :save_to_zoho
  after_update :update_zoho

  def save_to_zoho
    if LegacyUser.find_by_email(self.email)
      puts "DONT SAVE TO ZOHO!!!!!!!!!!"
    else
      SaveToZohoJob.perform_later self
      puts "SAVE TO ZOHO!!!!!!"
    end
  end

  def update_zoho
    UpdateZohoJob.perform_later self
  end
  # takes time for zoho record to propogate through api, needs further testing
  handle_asynchronously :update_zoho, :run_at => Proc.new { 3.minutes.from_now }
end
