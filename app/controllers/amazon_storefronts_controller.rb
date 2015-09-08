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
      if(params[:amazon_product_ids].present?)
        params[:amazon_product_ids].each do |product_id|
          Recommendation.create(recommendable_id: product_id, amazon_storefront_id: @amazon_storefront.id, recommendable_type: 'AmazonProduct')
        end
      end
      redirect_to @amazon_storefront
    else
      render :new
    end
  end

  def show
    @amazon_storefront = AmazonStorefront.find_by_url(params[:id])
    @tasks = @amazon_storefront.recommendations.tasks
    @products = @amazon_storefront.recommendations.products
    render layout: 'storefront'
  end

  def index
    @amazon_storefronts = AmazonStorefront.all
  end

  private

  def amazon_storefront_params
    params.require(:amazon_storefront).permit(:lead_name, :lead_email, :concierge_id, :recommendations_attributes => [:amazon_product_id])
  end

end