# == Schema Information
#
# Table name: notification_users
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notification_id :integer
#  day             :string           default("Everyday")
#  time            :integer          default(21)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_notification_users_on_notification_id              (notification_id)
#  index_notification_users_on_user_id                      (user_id)
#  index_notification_users_on_user_id_and_notification_id  (user_id,notification_id)
#
# Foreign Keys
#
#  fk_rails_322b2277b4  (notification_id => notifications.id)
#  fk_rails_40109e8fb1  (user_id => users.id)
#



class NotificationUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification

  validates :user, presence: true
  validates :notification, presence: true
end
