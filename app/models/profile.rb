class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class Profile < ActiveRecord::Base

  belongs_to :user
  belongs_to :availability
  has_many :interests, dependent: :destroy
  has_many :offerings, through: :interests

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true, email: true

  after_create :save_to_zoho
  after_update :update_zoho

  def save_to_zoho
    SaveToZohoJob.perform_later self
  end

  def update_zoho
    UpdateZohoJob.perform_now self
    # UpdateZohoJob.perform_later self

  end
end
