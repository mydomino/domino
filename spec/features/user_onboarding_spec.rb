require 'rails_helper'
require 'support/wait_for_ajax'

RSpec.feature "User Onboarding", :type => :feature, js: true, focus: true do

  scenario "User steps through onboarding" do
    offering = FactoryGirl.create(:offering, name: "Clean Power Options")
    visit "/"

    fill_in 'profile_first_name', with: "Foo"
    fill_in 'profile_last_name', with: "Bar"
    fill_in 'profile_email', with: "foo@bar.com"
    click_on 'GET STARTED'
    wait_for_ajax
    expect(page).to have_content("Clean Power Options")
  end

end