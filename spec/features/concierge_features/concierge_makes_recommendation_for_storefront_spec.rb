require 'rails_helper'

RSpec.feature "Concierge makes a recommendation" do

  let(:concierge) { FactoryGirl.create(:concierge) }
  let!(:storefront) { FactoryGirl.create(:amazon_storefront) }
  let!(:product) { FactoryGirl.create(:amazon_product) }

  scenario "for an existing storefront" do
    login_as(concierge, scope: :concierge)

    visit amazon_storefronts_path
    click_on "Make Recommendation"
    select product.name
    fill_in 'comment', with: Faker::Lorem.paragraph
    click_on 'Save'
  end
end