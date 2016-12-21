# == Schema Information
#
# Table name: legacy_users
#
#  id                   :integer          not null, primary key
#  email                :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  dashboard_registered :boolean          default(FALSE)
#

class LegacyUser < ActiveRecord::Base
  validates :email, uniqueness: true
end
