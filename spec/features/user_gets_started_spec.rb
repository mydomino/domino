require 'rails_helper'

RSpec.feature "User follows the 'Get Started' flow to sign up" do

  let(:campaign_name) { Faker::Lorem.words(3).join('_') }

  scenario "beginning on the home page", js: true do
    visit "#{root_path}?utm_campaign=#{campaign_name}"
    first('.btn').click_link('Get Started')
    find('#solar').click
    click_on 'Next'
    fill_in :get_started_area_code, with: '12345'
    click_on 'Next'
    fill_in :lead_first_name, with: "Josh"
    fill_in :lead_last_name, with: "Morrow"
    find('#email').click
    fill_in :lead_email, with: "josh@mydomino.com"
    click_on "Complete"


    expect(page).to have_content("Thanks Josh Morrow")
    expect(Lead.count).to eq(1)
    expect(Lead.first.campaign).to eq(campaign_name)
  end


  scenario 'user selects solar by clicking on the icon' do
    
  end

end
