class ChangeAmazonProductToProduct < ActiveRecord::Migration
  def change
    rename_table :amazon_products, :products
  end

  Recommendation.where(recommendable_type: 'AmazonProduct').each do |recommendation|
    recommendation.update_attribute(:recommendable_type, 'Product')
  end

end
