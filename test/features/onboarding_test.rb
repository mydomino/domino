require 'test_helper'

feature "Onboarding" do
  scenario "Successful onboarding", js: true do

    visit root_path
    
    #name and email form
    fill_in 'First name', with: 'Foo'
    fill_in 'Last name', with: 'Bar'
    fill_in 'Email address', with: 'foo@bar.com'
    click_button 'Get started'

    #ensure profile name and email info is captured
    profile = Profile.last
    assert profile.first_name == 'Foo'
    assert profile.last_name == 'Bar'
    assert profile.email == 'foo@bar.com'


    #interests form
    find("#interest_1").click
    find("#interest_5").click

    click_button 'Next'

    interests = Profile.last.interests
    interests.each do |interest|
      assert [1,5].include? interest.offering_id
    end

    #living situation
    fill_in 'profile_phone', with: '1234567890'
    fill_in 'profile_address_line_1', with: '123 Fake St.'
    fill_in 'profile_city', with: 'Palo Alto'
    find('#profile_state').find(:xpath, 'option[2]').select_option
    fill_in 'profile_zip_code', with: '94306'
    click_button 'Rent'

    click_button 'Next'
    
    profile = Profile.last

    assert profile.phone == '(123) 456-7890'
    assert profile.address_line_1 == '123 Fake St.'
    assert profile.city ==  'Palo Alto'
    assert profile.state == 'AK'
    assert profile.zip_code == '94306'
    assert profile.housing == 'rent'

    #checkout

    fill_in 'profile_partner_code', with: 'CHOOSE'
    click_button 'Submit'

    profile = Profile.last
    assert profile.partner_code.code == 'CHOOSE'

    #summary
    page.must_have_content "Thanks for signing up, Foo!"
  end
end