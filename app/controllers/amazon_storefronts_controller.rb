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
    if @amazon_storefront.save
      params[:amazon_storefront][:amazon_product_ids].each do |product_id|
        Recommendation.create(amazon_product_id: product_id, amazon_storefront_id: @amazon_storefront.id)
      end
      redirect_to @amazon_storefront
    else
      render :new
    end
  end

  def show
    @amazon_storefront = AmazonStorefront.find_by_url(params[:id])
  end

  def index
    @amazon_storefronts = AmazonStorefront.all
  end

  private

  def amazon_storefront_params
    params.require(:amazon_storefront).permit(:lead_name, :concierge_id, :recommendations_attributes => [:amazon_product_id])
  end

end