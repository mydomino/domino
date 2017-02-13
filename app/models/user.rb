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
#  meal_carbon_footprint  :float            default(0.0)
#  fat_reward_points      :integer          default(0)
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
  has_many :meal_days, dependent: :destroy
  has_many :points_logs, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # after_create :schedule_geocode, :deliver_thank_you_email, :save_to_zoho, :upload_subscription_to_mailchimp
  mailkick_user

  # /email_sign_up_link/
  # Purpose: Send signup links to org members who have User accounts previously
  #  created by an org admin.
  def email_signup_link
    # Email signup link is valid until a password is successfully reset
    if self.signup_token.nil?
      generate_token(:signup_token)
    end
    self.save
    UserMailer.email_signup_link(self).deliver_later
  end

  
  # calculate the food carbon footprint during a period
  # Note: start_date is today/current date, end_date is yesterday or before today date
  def get_fat_carbon_footprint(start_date, end_date = nil)

    
    # determine whether end_date is given. If not given, use start_date as end_date
    end_date = end_date.nil? ? start_date : end_date


    @total_carbon_foodprint = 0

    meal_days = self.meal_days.where(["date <= ? and date >= ?", start_date, end_date])

    carbon_foodprints = meal_days.map(&:carbon_footprint) if meal_days != nil 

    # sum up value in the array
    @total_carbon_foodprint = carbon_foodprints.inject(:+) if carbon_foodprints!= nil


    # update the carbon footprint value
    self.meal_carbon_footprint = @total_carbon_foodprint

    self.save!

    return (self.meal_carbon_footprint)
    
  end
 
  # calculate user reward points during the period and save it to the user's member variable
  def get_fat_reward_points(start_date, end_date = nil)

    # determine whether end_date is given. If not given, use start_date as end_date
    end_date = end_date.nil? ? start_date : end_date

    points_log = self.points_logs.where(["point_date <= ? and point_date >= ?", start_date, end_date])

    # return a points array
    points = points_log.map(&:point) if points_log.size > 0

    # sum up the points
    if points != nil
      self.fat_reward_points = points.inject(:+) 
      self.save!
    end

    return(self.fat_reward_points)
    
  end

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
