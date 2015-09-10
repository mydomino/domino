class AmazonStorefront < ActiveRecord::Base
  extend FriendlyId
  friendly_id :lead_name, use: :slugged

  has_many :recommendations
  has_many :amazon_products, through: :recommendations, source: :recommendable, source_type: :AmazonProduct
  belongs_to :concierge


end