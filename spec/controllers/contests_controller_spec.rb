require 'rails_helper'
require 'contests_controller'
include Devise::TestHelpers

describe ContestsController, focus: true do

  let(:concierge){ FactoryGirl.create(:concierge) }

  it 'should require login to access the new page' do

    sign_in concierge

    get :new

    expect(response).to have_http_status :success

  end

end