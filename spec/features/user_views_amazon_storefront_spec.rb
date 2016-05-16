require 'rails_helper'

RSpec.feature "User views dashboard", :type => :feature do

  # let!(:product) { FactoryGirl.create(:product) }
  # let!(:concierge) { FactoryGirl.create(:concierge) }
  # let!(:dashboard) { FactoryGirl.create(:dashboard, concierge: concierge, lead_name: "John Doe") }

  # scenario "to buy a product from Amazon" do
  #   dashboard.products << product

  #   visit dashboard_path dashboard

  #   expect(page).to have_content dashboard.lead_name
  #   expect(page).to have_css('.recommendation', text: product.name)
  # end

  # scenario "to mark an item as purchased" do
  #   dashboard.products << product  

  #   visit dashboard_path dashboard
  #   expect(page).not_to have_css('.bg-blue.white.center.p2.rounded-20-top')

  #   click_on("I've bought this")

  #   expect(page).to have_css('.bg-blue.white.center.p2.rounded-20-top')
  # end

end