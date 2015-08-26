class AmazonStorefrontsController < ApplicationController
  def new
    @amazon_storefront = AmazonStorefront.new
  end
end