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

class Dashboard < ActiveRecord::Base
  # extend FriendlyId
  # friendly_id :slug_candidates, use: :slugged
  has_many :recommendations, dependent: :destroy
  has_many :products, through: :recommendations, source: :recommendable, source_type: :Product
  has_many :tasks, through: :recommendations, source: :recommendable, source_type: :Task

  belongs_to :user

  after_create :set_default_recommendations

  private

  def set_default_recommendations
    self.products = Product.default
    self.tasks = Task.default
  end

end
