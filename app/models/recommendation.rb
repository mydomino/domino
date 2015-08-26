class Recommendation < ActiveRecord::Base
  belongs_to :amazon_storefront
  belongs_to :amazon_product
end