# == Schema Information
#
# Table name: dashboards
#
#  id                         :integer          not null, primary key
#  lead_name                  :string
#  recommendation_explanation :text
#  concierge_id               :integer
#  slug                       :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  lead_email                 :string
#  user_id                    :integer
#
# Indexes
#
#  index_dashboards_on_concierge_id  (concierge_id)
#  index_dashboards_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_8cb1930a1d  (user_id => users.id)
#

require "test_helper"

class DashboardTest < ActiveSupport::TestCase

  should have_many(:recommendations)
  should have_many(:products)
  should have_many(:tasks)
  should belong_to(:user)

  def dashboard
    @dashboard ||= Dashboard.new
  end

  def test_valid
    assert dashboard.valid?
  end
end
