task :update_all_product_prices => :environment do
  UpdateAllAmazonPricesJob.perform_later
end
