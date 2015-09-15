class AmazonStorefrontsController < ApplicationController
  before_action :authenticate_concierge!, except: :show
  layout 'concierge'

  def new
    @amazon_storefront = AmazonStorefront.new
    @amazon_products = AmazonProduct.all
    @concierges = Concierge.all
  end

  def create
    @amazon_storefront = AmazonStorefront.create(amazon_storefront_params)
    @amazon_storefront.concierge = current_concierge
    if @amazon_storefront.save
      redirect_to @amazon_storefront
    else
      render :new
    end
  end

  def show
    @storefront = AmazonStorefront.friendly.find(params[:id])
    @recommendation = @storefront.recommendations.build
    @tasks = @storefront.recommendations.tasks
    @products = @storefront.recommendations.products
    render layout: 'storefront'
  end

  def index
    @amazon_storefronts = AmazonStorefront.where(concierge: current_concierge)
  end

  private

  def amazon_storefront_params
    params.require(:amazon_storefront).permit(:lead_name, :lead_email, :concierge_id, :recommendations_attributes => [:amazon_product_id])
  end

end