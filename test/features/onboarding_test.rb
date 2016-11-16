require 'test_helper'

def fill_name_and_email_fields_for_foo_bar
  fill_in 'First name', with: 'Foo'
  fill_in 'Last name', with: 'Bar'
  fill_in 'Email address', with: 'foo@bar.com'
end

class OnboardingTest < Minitest::Test

  feature "Onboarding" do
    scenario "Successful onboarding" do

      visit root_path
      fill_name_and_email_fields_for_foo_bar
      #name and email form
      
      click_button 'Get started'

      #interests form
      page.must_have_content "What are you interested in?"

      find("#interest_1").click
      find("#interest_5").click

      click_button 'Next'

      #your house form
      page.must_have_content "Tell us a bit about your home"

      fill_in 'profile_phone', with: '1234567890'
      fill_in 'profile_address_line_1', with: '123 Fake St.'
      fill_in 'profile_city', with: 'Palo Alto'
      find('#profile_state').find(:xpath, 'option[2]').select_option
      fill_in 'profile_zip_code', with: '94306'
      click_button 'Rent'

      click_button 'Next'
      
      #checkout form
      page.must_have_content "Your MyDomino Membership"

      fill_in 'profile_partner_code', with: 'CHOOSE'
      click_button 'Submit'

      #summary page
      page.must_have_content "Thanks for signing up, Foo!"
    end

    scenario "Onboarding continued" do
      #user begins onboarding
      visit root_path
      fill_name_and_email_fields_for_foo_bar
      click_button 'Get started'

      #returns to interests form
      visit root_path
      fill_name_and_email_fields_for_foo_bar
      click_button 'Get started'

      #flash notice with welcome back message
      page.must_have_content "Welcome back, Foo! Here is where you left off."
      page.must_have_content "What are you interested in?"
      click_button "Next"

      #returns to your house form
      visit root_path
      fill_name_and_email_fields_for_foo_bar
      click_button 'Get started'
      page.must_have_content "Welcome back, Foo! Here is where you left off."
      page.must_have_content "Tell us a bit about your home"
      click_button "Next"

      #onboarding considered complete at this point
      #user attempts to onboard again, they should be taken to the onboarding summary page
      visit root_path
      fill_name_and_email_fields_for_foo_bar
      click_button 'Get started'
      page.must_have_content "Thanks for signing up, Foo!"
    end
  end
end