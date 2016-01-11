require 'rails_helper'
require 'contests_controller'
include Devise::TestHelpers

describe ContestsController do

  let(:concierge){ FactoryGirl.create(:concierge) }

  it 'should require login to access the new page' do
    sign_in concierge

    get :new

    expect(response).to have_http_status :success
  end

  it 'shows a standard signup page if the contest is over' do
    contest = FactoryGirl.create(:contest, end_date: Date.today - 1)

    get :show, id: contest.id

    expect(response).to redirect_to('/')
  end


  it 'shows the contest page if the contest is still going' do
    contest = FactoryGirl.create(:contest, end_date: Date.today + 1)

    get :show, id: contest.id

    expect(response).to have_http_status(200)
  end


end