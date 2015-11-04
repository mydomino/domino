require 'rails_helper'

RSpec.feature 'Concierge edits contest page' do

  let!(:contest) { FactoryGirl.create(:contest) }
  let(:concierge) { FactoryGirl.create(:concierge) }

  scenario 'through the contests page' do
    login_as(concierge, scope: :concierge)

    visit contests_path
    click_on 'Edit Contest'
    fill_in :contest_headline, with: 'A cool new headline'
    click_on 'Save Changes'

    expect(page).to have_content('A cool new headline')

  end

end