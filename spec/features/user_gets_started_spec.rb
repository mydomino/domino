require 'rails_helper'

RSpec.feature "User follows the 'Get Started' flow to sign up" do

  scenario "beginning on the home page", focus: true do
    visit root_path
    click_on 'Get Started'
    find('#solar').click
    click_on 'Next'
  end

  scenario 'and two comes after one' do
    visit step_1_get_started_path

    click_on 'Next'

    expect(current_path).to eq(step_2_get_started_path)
  end

  scenario 'and three comes after two'

  scenario 'after completing all fields and submitting a lead is created'

end