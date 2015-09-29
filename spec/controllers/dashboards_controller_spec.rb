require 'rails_helper'
require 'dashboards_controller'

describe DashboardsController do

  it 'requires authentication for index' do
    expect { get :index }.to raise_error("undefined method `authenticate!' for nil:NilClass")
  end

  it 'does not require authentication to view a dashboard' do
    dashboard = FactoryGirl.create(:dashboard)

    get :show, id: dashboard.id

    expect(response).to have_http_status(:success)
  end

  it 'can find dashboards by their slugs' do
    dashboard = FactoryGirl.create(:dashboard)

    get :show, id: dashboard.slug

    expect(response).to have_http_status(:success)
  end

end