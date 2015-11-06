require 'rails_helper'

RSpec.feature "User follows the 'Get Started' flow to sign up" do

  scenario "beginning on the home page", js: true do
    visit root_path
    click_on 'Get Started'
    find('#solar').click
    click_on 'Next'
    fill_in :get_started_area_code, with: '12345'
    click_on 'Next'
    fill_in :lead_first_name, with: "Josh"
    fill_in :lead_last_name, with: "Morrow"
    find('#email').click
    fill_in :lead_email, with: "josh@mydomino.com"
    click_on "Next"
    sleep 5

    expect(Lead.count).to eq(1)
  end

  scenario 'user selects solar by clicking on the icon' do
    
  end

end