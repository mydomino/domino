# == Schema Information
#
# Table name: profiles
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  first_name            :string
#  last_name             :string
#  email                 :string
#  phone                 :string
#  address_line_1        :string
#  city                  :string
#  state                 :string
#  zip_code              :string
#  housing               :string
#  avg_electrical_bill   :integer          default(0)
#  onboard_complete      :boolean          default(FALSE)
#  onboard_step          :integer          default(1)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  dashboard_registered  :boolean          default(FALSE)
#  campaign              :string
#  ip                    :string
#  referer               :string
#  browser               :string
#  partner_code_id       :integer
#  welcome_tour_complete :boolean          default(FALSE)
#  fat_intro_complete    :boolean          default(FALSE)
#  time_zone             :string           default("(GMT-08:00) Pacific Time (US & Canada)")
#
# Indexes
#
#  index_profiles_on_partner_code_id  (partner_code_id)
#  index_profiles_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_7c48a5d7d6  (partner_code_id => partner_codes.id)
#  fk_rails_e424190865  (user_id => users.id)
#



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

  #BEGIN wicked multistep form specific code
  
  #validates :name, :owner_name, presence: true, if: -> { required_for_step?(:identity)
  # with_options if: -> { required_for_step?(:identity) } do |step|
  #   step.validates :first_name, :last_name, :email, presence: true
  # end

  cattr_accessor :form_steps do
    %w(interests your_house checkout summary)
  end

  attr_accessor :form_step

  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?

    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    return true if self.form_steps.index(step.to_s) <= self.form_steps.index(form_step)
  end

  #END wicked mutlistep form specific code
  def save_to_zoho
    SaveToZohoJob.perform_later self
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
