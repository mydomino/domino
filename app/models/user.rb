# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string           default("lead")
#  organization_id        :integer
#  signup_token           :string
#  signup_token_sent_at   :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_organization_id       (organization_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_d7b9ff90af  (organization_id => organizations.id)
#


class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_one :profile, dependent: :destroy
  has_one :dashboard, dependent: :destroy
  belongs_to :organization, counter_cache: true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # after_create :schedule_geocode, :deliver_thank_you_email, :save_to_zoho, :upload_subscription_to_mailchimp
  mailkick_user

  # /email_sign_up_link/
  # Purpose: Send signup links to org members who have User accounts previously
  #  created by an org admin.
  def email_signup_link
    generate_token(:signup_token)
    self.save
    UserMailer.email_signup_link(self).deliver_later
    puts "User #{self.email} signup token emails on #{PostsHelper::format_post_date(self.signup_token_sent_at.to_s)}\n"
  end

  # email signup_token to user
  #def email_onboard_url(first_name, last_name)
  #  # generate a new signup token
  #  generate_token(:signup_token)
#
  #  # save the signup token sent date
  #  self.signup_token_sent_at = Time.zone.now
#
  #  save!
#
  #  org_name = self.organization.nil? ? '' : self.organization.name
#
  #  UserMailer.email_user_with_on_board_url(org_name, first_name, last_name, self.email, self.signup_token).deliver_now
#
  #  puts "User #{self.email} signup token emails on #{PostsHelper::format_post_date(self.signup_token_sent_at.to_s)}\n"
  #end

  ###############################################################################################################
  private

  # genareate a secure random token for a given column name in the user table
  def generate_token(column_name)
  	# keep looping until no user with such token
    begin
      self[column_name] = SecureRandom.urlsafe_base64
      self.signup_token_sent_at = Time.zone.now
    end while User.exists?(column_name => self[column_name])
  end
end
