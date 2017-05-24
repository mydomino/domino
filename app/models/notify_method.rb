# == Schema Information
#
# Table name: notify_methods
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
#  index_notify_methods_on_notification_id  (notification_id)
#
# Foreign Keys
#
#  fk_rails_adbe98f27f  (notification_id => notifications.id)
#




class NotifyMethod < ActiveRecord::Base
  belongs_to :notification
end
