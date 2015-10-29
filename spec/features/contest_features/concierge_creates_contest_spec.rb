require 'rails_helper'

RSpec.feature 'Concierge creates new contest' do
  let(:concierge) { FactoryGirl.create(:concierge) }
  scenario 'through the new contest page' do
    login_as(concierge, scope: :concierge)

    visit new_contest_path
    fill_in :contest_name, with: 'Random name'
    fill_in :contest_headline, with: 'Random Headline'
    select '2020', from: :contest_end_date_1i
    select 'October', from: :contest_end_date_2i
    select '10', from: :contest_end_date_3i
    click_on "Create Contest"

    expect(page).to have_content('Random Headline')
  end

end