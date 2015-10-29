require 'rails_helper'

RSpec.feature 'User views contest page' do

  scenario 'and expects to see the headline and the end date' do
    contest = FactoryGirl.create(:contest, name: "My Fancy Giveaway", end_date: Date.today + 5)

    visit contest_path(contest)

    expect(page).to have_content("My Fancy Giveaway")

  end

  scenario 'and expects to see the beginning and end dates in the rules' do

    contest = FactoryGirl.create(:contest, name: "My Fancy Giveaway", end_date: Date.today + 5)

    visit contest_path(contest)

    expect(page).to have_content(contest.end_date.strftime('%B %e, %Y'))
    expect(page).to have_content(contest.start_date.strftime('%B %e, %Y'))

  end

end