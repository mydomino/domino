class Recommendation < ActiveRecord::Base
  belongs_to :amazon_storefront
  belongs_to :recommendable, polymorphic: true
end