require 'rails_helper'

RSpec.feature "Concierge deletes dashboard" do

  let(:concierge) { FactoryGirl.create(:concierge) }
  let!(:dashboard) {FactoryGirl.create(:dashboard, concierge: concierge)}

  scenario "by hitting the delete button", focus:true, js: true do
    login_as(concierge, scope: :concierge)

    visit dashboards_path

    expect(page).to have_content dashboard.lead_name
    click_on "Delete"
    page.driver.browser.switch_to.alert.accept

    expect(Dashboard.count).to eq(0)
  end
end