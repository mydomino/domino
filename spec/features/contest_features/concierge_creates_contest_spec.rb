require 'rails_helper'

RSpec.feature 'Concierge creates new contest' do
  let(:concierge) { FactoryGirl.create(:concierge) }
  scenario 'through the new contest page' do
    login_as(concierge, :scope => :concierge)

    visit new_contest_path
    fill_in :contest_name, with: 'Random name'
    select '2015', from: :contest_end_date_1i
    select 'October', from: :contest_end_date_2i
    select '10', from: :contest_end_date_3i
    click_on "Create Contest"
  end

end