class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "is not an email")
    end
  end
end

class Profile < ActiveRecord::Base

  belongs_to :user
  belongs_to :partner_code
  has_many :interests, dependent: :destroy
  has_many :offerings, through: :interests
  accepts_nested_attributes_for :offerings, :partner_code
  
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true, email: true

  before_save :downcase_email
  after_create :send_onboard_started_email

  def save_to_zoho
    if LegacyUser.find_by_email(self.email)
    else
      SaveToZohoJob.perform_later self
    end
  end

  def send_onboard_started_email
    UserMailer.onboard_started(self).deliver_later
  end

  #method to minimize api calls to zoho on lead profile updates
  def delete_redundant_delayed_jobs
    djs = Delayed::Job.where('handler LIKE ?', "%job_class: UpdateZohoJob%gid%/Profile/#{self.id}%").order(created_at: :desc)
    if djs.count > 1
      djs.where('created_at < ?', djs.first.created_at).destroy_all
    end
  end
  handle_asynchronously :delete_redundant_delayed_jobs

  def update_zoho
    #destroy other update operations on same zoho record to minimize zoho api calls
    delete_redundant_delayed_jobs
    # takes time for zoho record to propogate through api, needs further testing
    UpdateZohoJob.set(wait: 3.minutes).perform_later self
  end

  def downcase_email
    self.email.downcase!
  end
end
