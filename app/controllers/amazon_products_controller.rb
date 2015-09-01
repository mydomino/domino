class AmazonProductsController < ApplicationController
  layout 'concierge'

  def new
    @amazon_product = AmazonProduct.new
  end

  def create
    @amazon_product = AmazonProduct.new(create_amazon_product_params)
    if @amazon_product.save
      redirect_to edit_amazon_product_path @amazon_product
    else
      render :new
    end
  end

  def edit
    @amazon_product = AmazonProduct.find(params[:id])
  end

  def update
    @amazon_product = AmazonProduct.find(params[:id])
    if @amazon_product.update_attributes(edit_amazon_product_params)
      redirect_to amazon_products_path
    else
      render :edit
    end
  end

  def index
    @amazon_products = AmazonProduct.all
  end

  private

  def create_amazon_product_params
    params.require(:amazon_product).permit(:product_id, :url)
  end

  def edit_amazon_product_params
    params.require(:amazon_product).permit(:name, :description)
  end
end