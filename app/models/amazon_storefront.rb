class AmazonStorefront < ActiveRecord::Base
  has_many :recommendations
  has_many :amazon_products, through: :recommendations
  belongs_to :concierge
  acts_as_url :lead_name

  def to_param
    url
  end
end