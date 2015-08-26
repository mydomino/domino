class AmazonStorefrontsController < ApplicationController
  layout 'concierge'

  def new
    @amazon_storefront = AmazonStorefront.new
    @amazon_products = AmazonProduct.all
  end
end