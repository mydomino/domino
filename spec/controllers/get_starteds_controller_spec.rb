require 'rails_helper'
require 'get_starteds_controller'


describe GetStartedsController do

  let(:campaign_name) { Faker::Lorem.words(3).join('_') }

  it 'captures the utm_campaign variable' do
    get :step_1, utm_campaign: campaign_name

    expect(request.session[:campaign]).to eq(campaign_name)
  end

  it 'stores the get_started in the session after POSTing to any step' do
    get :step_2
    
    expect(session[:get_started_id]).not_to be_nil
  end

end
