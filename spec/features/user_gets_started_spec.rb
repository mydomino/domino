require 'rails_helper'

RSpec.feature "User follows the 'Get Started' flow to sign up" do

  scenario "beginning on the home page", focus: true do
    visit root_path
    click_on 'Get Started'
    find('#solar').click
    click_on 'Next'
    fill_in :get_started_area_code, with: '12345'
    click_on 'Next'
    fill_in :get_started_first_name, with: "Josh"
    fill_in :get_started_last_name, with: "Morrow"
    find('#phone').click
    click_on "Next"

    #expect(page.get_rack_session_key('get_started')).not_to be_nil

  end

  scenario 'user selects solar by clicking on the icon' do
    
  end

end