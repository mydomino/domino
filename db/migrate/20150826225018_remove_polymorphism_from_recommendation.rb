class RemovePolymorphismFromRecommendation < ActiveRecord::Migration
  def change
    remove_column :recommendations, :recommendable_id
    remove_column :recommendations, :recommendable_type

    add_column :recommendations, :amazon_product_id, :integer
  end
end

