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
  after_update :delete_redundant_delayed_jobs, :update_zoho
  # after_update :update_zoho

  def save_to_zoho
    if LegacyUser.find_by_email(self.email)
      puts "DONT SAVE TO ZOHO!!!!!!!!!!"
    else
      SaveToZohoJob.perform_later self
      puts "SAVE TO ZOHO!!!!!!"
    end
  end

  #method to minimize api calls to zoho
  def delete_redundant_delayed_jobs
    djs = Delayed::Job.where('handler LIKE ?', "%id: '#{self.id}'%:update_zoho%").order(created_at: :desc)
    if djs.count > 1
      last_update_job = djs.first
      Delayed::Job.where('created_at < ?', last_update_job.created_at).destroy_all
    end
  end
  handle_asynchronously :delete_redundant_delayed_jobs

  def update_zoho
    #destroy other update operations on same zoho record to minimize zoho api calls

    UpdateZohoJob.perform_later self
  end
  # takes time for zoho record to propogate through api, needs further testing
  handle_asynchronously :update_zoho, :run_at => Proc.new { 3.minutes.from_now }
end
