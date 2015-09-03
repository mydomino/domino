require 'rails_helper'

RSpec.feature "Concierge edits their own information" do
  
  let!(:concierge) { FactoryGirl.create(:concierge) }

  scenario "successfully" do
    login_as(concierge, scope: :concierge)
    name = Faker::Name.name

    visit edit_concierge_path
    fill_in 'Name', with: name
    click_on "Save"

    expect(current_path).to eq(amazon_products_path)
    expect(page).to have_content(name)
  end

end