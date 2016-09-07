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