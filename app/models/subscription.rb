# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  start_date       :datetime
#  expire_date      :datetime
#  max_member_count :integer
#  organization_id  :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_subscriptions_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_364213cc3e  (organization_id => organizations.id)
#



class Subscription < ActiveRecord::Base
  belongs_to :organization
end
