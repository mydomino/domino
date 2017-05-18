# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  day         :string
#  time        :integer          default(21)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#

class Notification < ActiveRecord::Base
  has_many :notification_users 
  has_many :users, through: :notification_users
  has_many :notify_methods, dependent: :destroy

  validates :description, presence: true
end
