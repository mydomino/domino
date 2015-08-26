class AmazonStorefront < ActiveRecord::Base
  has_many :recommendations
  has_many :amazon_products, through: :recommendations
end