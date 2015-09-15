require 'rails_helper'

RSpec.feature "User sees comments on products" do

  let(:concierge) { FactoryGirl.create(:concierge) }
  let(:storefront) { FactoryGirl.create(:dashboard, concierge: concierge) }
  let(:product) { FactoryGirl.create(:amazon_product) }
  let(:comment) { Faker::Lorem.paragraph }
  let!(:recommendation) { FactoryGirl.create(:recommendation, dashboard: storefront, recommendable: product, comment: comment) }

  scenario "by viewing their storefront" do 
    visit dashboard_path storefront

    expect(page).to have_css('.amazon_product')
    expect(page).to have_css('.comment-box', text: comment)
  end

end