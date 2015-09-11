class Recommendation < ActiveRecord::Base
  belongs_to :amazon_storefront
  belongs_to :recommendable, polymorphic: true
  belongs_to :concierge
  validates :recommendable_id, uniqueness: {scope: [:amazon_storefront_id, :recommendable_type] }
  scope :tasks, -> { where(recommendable_type: 'Task') }
  scope :products, -> { where(recommendable_type: 'AmazonProduct') }
  scope :done, -> { where(done: true) }

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