# == Schema Information
#
# Table name: group_users
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  group_id         :integer
#  datetime_sign_in :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_group_users_on_group_id              (group_id)
#  index_group_users_on_user_id               (user_id)
#  index_group_users_on_user_id_and_group_id  (user_id,group_id)
#
# Foreign Keys
#
#  fk_rails_1486913327  (user_id => users.id)
#  fk_rails_a9d5f48449  (group_id => groups.id)
#



class GroupUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates :user, presence: true
  validates :group, presence: true

end
