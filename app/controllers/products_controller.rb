class ProductsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  layout 'concierge'

  def index
    authorize Product
    @default_products = Product.where(default: true)
    @non_default_products = Product.where(default: false)
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    authorize @product
  end

  def create
    @product = Product.new(create_product_params)
    authorize @product

    if @product.save
      redirect_to edit_product_path @product
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
    authorize @product
  end

  def update
    authorize Product
    @product = Product.find(params[:id])
    if @product.update_attributes(edit_product_params)
      redirect_to products_path
    else
      render :edit
    end
  end

  def update_all_amazon_prices
    authorize Product
    UpdateAllAmazonPricesJob.perform_later
    redirect_to :products
  end

  def toggle_default
    @product = Product.find(params[:product_id])
    @product.default = !@product.default
    @product.save
    redirect_to products_path
  end

  def destroy
    authorize Product
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end

  private

  def create_product_params
    params.require(:product).permit(:product_id, :url)
  end

  def edit_product_params
    params.require(:product).permit(:name, :description)
  end
end