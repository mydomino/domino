require 'rails_helper'

RSpec.feature "User views dashboard", :type => :feature do

  let!(:product) { FactoryGirl.create(:product) }
  let!(:concierge) { FactoryGirl.create(:concierge) }
  let!(:dashboard) { FactoryGirl.create(:dashboard, concierge: concierge) }

  scenario "to buy a product from Amazon" do
    dashboard.products << product

    visit dashboard_path dashboard

    expect(page).to have_content dashboard.lead_name
    expect(page).to have_css('.product', text: product.name)
  end

  scenario "to mark an item as purchased" do
    dashboard.products << product  

    visit dashboard_path dashboard
    expect(page).not_to have_css('.product .status.completed')

    click_on("I've bought this")

    expect(page).to have_css('.product .status.completed')
  end

end