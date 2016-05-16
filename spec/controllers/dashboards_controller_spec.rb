require 'rails_helper'
require 'dashboards_controller'

describe DashboardsController do

  it 'requires authentication for index' do
    get :index
    expect(response).to redirect_to '/users/sign_in'
  end

end