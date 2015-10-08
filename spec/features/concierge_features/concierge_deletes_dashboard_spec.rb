require 'rails_helper'

RSpec.feature "Concierge deletes dashboard" do

  let(:concierge) { FactoryGirl.create(:concierge) }
  let!(:dashboard) {FactoryGirl.create(:dashboard, concierge: concierge)}

  scenario "by hitting the delete button", js: true do
    login_as(concierge, scope: :concierge)

    visit dashboards_path

    expect(page).to have_content dashboard.lead_name.upcase
    click_on "Delete"
    page.driver.browser.switch_to.alert.accept
    expect(page).not_to have_content(dashboard.lead_name)
    expect(Dashboard.count).to eq(0)
  end
end