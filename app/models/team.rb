# == Schema Information
#
# Table name: teams
#
#  id              :integer          not null, primary key
#  name            :string
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_teams_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_f07f0bd66d  (organization_id => organizations.id)
#



class Team < ActiveRecord::Base
  belongs_to :organization
end
