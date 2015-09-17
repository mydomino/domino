class Recommendation < ActiveRecord::Base
  belongs_to :dashboard
  belongs_to :recommendable, polymorphic: true
  belongs_to :concierge
  validates :recommendable_id, uniqueness: {scope: [:dashboard_id, :recommendable_type] }
  validates :dashboard_id, presence: true
  default_scope { order("done DESC") }
  scope :tasks, -> { where(recommendable_type: 'Task') }
  scope :products, -> { where(recommendable_type: 'Product') }
  after_create :assign_concierge
  scope :done, -> { where(done: true) }

  def assign_concierge
    self.update_attribute(:concierge_id, dashboard.concierge_id)
  end

  def global_recommendable
    self.recommendable.to_global_id if self.recommendable.present?
  end

  def gid_string
    global_recommendable.to_s
  end

  def global_recommendable=(recommendable_gid)
    self.recommendable = GlobalID::Locator.locate recommendable_gid
  end
end