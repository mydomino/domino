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
#  local_send_time :integer
#  sent_at         :datetime
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

  after_create :convert_time_to_local
  after_update :convert_time_to_local

  private

  def convert_time_to_local
    timezone = self.user.profile.time_zone

    Time.now.in_time_zone(timezone).utc_offset # 9pm EST - offset: -4 hours

    send_at_hour = (self.time - Time.now.in_time_zone(timezone).utc_offset / (60*60))%24

    self.update_column(:local_send_time, send_at_hour)
  end
end
