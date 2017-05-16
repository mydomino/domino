# == Schema Information
#
# Table name: notifications
#
#  id         :integer          not null, primary key
#  day        :string
#  time       :integer          default(21)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_b080fb4855  (user_id => users.id)
#

class Notification < ActiveRecord::Base
  belongs_to :user
  has_one :notify_task, dependent: :destroy
  has_many :notify_methods, dependent: :destroy
end
