class AmazonProductsController < ApplicationController
  layout 'concierge'

  def new
    @amazon_product = AmazonProduct.new
  end

  def create
    @amazon_product = AmazonProduct.new(amazon_product_params)
    if @amazon_product.save
      redirect_to amazon_products_path
    else
      render :new
    end
  end

  def edit
    @amazon_product = AmazonProduct.find(params[:id])
  end

  def index
    @amazon_products = AmazonProduct.all
  end

  private

  def amazon_product_params
    params.require(:amazon_product).permit(:product_id, :url)
  end
end