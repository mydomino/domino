class UpdateAllAmazonPricesJob < ActiveJob::Base
  queue_as :default

  def perform
    Product.find_each do |product|
      product.update_amazon_price
    end
  end

end