# == Schema Information
#
# Table name: notify_tasks
#
#  id              :integer          not null, primary key
#  name            :string
#  desc            :string
#  notification_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_notify_tasks_on_notification_id  (notification_id)
#
# Foreign Keys
#
#  fk_rails_55297b50d7  (notification_id => notifications.id)
#

class NotifyTask < ActiveRecord::Base
  belongs_to :notification
end
