class AmazonProductsController < ApplicationController
  def new
    @amazon_product = AmazonProduct.new
  end
end