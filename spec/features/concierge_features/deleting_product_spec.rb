require 'rails_helper'

RSpec.feature "When tasks or products are deleted, so are the related recommendations" do

  let!(:dashboard) { FactoryGirl.create(:dashboard) }
  let!(:product) { FactoryGirl.create(:product) }

  scenario "by deleting a product from the products page" do
    #create a dashboard with the product
    recommendation = FactoryGirl.create(:recommendation, recommendable_type: "Product", recommendable_id: product.id, dashboard_id: dashboard.id)

    #delete the product from the products page
    product.destroy

    #check that the dashboard has no recommendations
    expect(dashboard.recommendations).not_to include(recommendation)
  end

end