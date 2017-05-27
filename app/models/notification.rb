# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#  name        :string
#


class Notification < ActiveRecord::Base
  has_many :notification_users 
  has_many :users, through: :notification_users
  has_many :notify_methods, dependent: :destroy

  validates :description, presence: true
  validates_presence_of :name
  validates :name, uniqueness: true

  # define constant name
  FAT_NOTIFICATION = "FAT_NOTIFICATION"
end
