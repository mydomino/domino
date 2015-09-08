class Recommendation < ActiveRecord::Base
  belongs_to :amazon_storefront
  belongs_to :recommendable, polymorphic: true
  belongs_to :concierge

  def global_recommendable
    self.recommendable.to_global_id if self.recommendable.present?
  end

  def global_recommendable=(recommendable_gid)
    self.recommendable = GlobalID::Locator.locate recommendable_gid
  end
end