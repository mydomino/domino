require 'rails_helper'

RSpec.feature 'Concierge views contest index page' do
  let(:concierge) { FactoryGirl.create(:concierge) }

  scenario 'and sees some contests' do
    login_as(concierge, scope: :concierge)

    visit contests_path

  end 

end