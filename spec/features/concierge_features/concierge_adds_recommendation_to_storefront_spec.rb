require 'rails_helper'

RSpec.feature "Concierge makes a recommendation", focus: true do

  let(:concierge) { FactoryGirl.create(:concierge) }
  let!(:storefront) { FactoryGirl.create(:amazon_storefront) }

  scenario "for an existing storefront" do
    login_as(concierge, scope: :concierge)

    visit amazon_storefronts_path
    click_on "Make Recommendation"
    select storefront.lead_name
    fill_in 'comment', with: Faker::Lorem.paragraph
    click_on 'Save'
  end
end